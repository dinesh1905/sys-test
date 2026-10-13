from PIL import Image
import numpy as np
import glob
import os
import cv2
# import pytesseract
import sys


# ---------------- CONFIG ----------------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
TEMPLATE_DIR = os.path.join(BASE_DIR, "templates")
DIGIT_SIZE = (80, 80)
# ----------------------------------------


def process_png_image(path, output_dir):
    # Find existing output files to generate next filename
    os.makedirs(output_dir, exist_ok=True)
    Imagefile = glob.glob(os.path.join(output_dir, "Grey_Raw_image*.jpg"))
    i = len(Imagefile) + 1
    # Path to raw file
    # path = r"C:\BITSRF\sys_test\project\config\Camera_Input\Camera_Image.png"
    width, height = 2560, 816
    print("Input path:", path)
    # Read raw data
    data = np.fromfile(path, dtype=np.uint8)
    if data.size != width * height:
        print("Width, Height Error")
    else:
        try:
            # Reshape and convert to image
            img = data.reshape((height, width))
            image = Image.fromarray(img)
            # Cropping width into half
            half_width = width // 2
            Final = image.crop((0, 0, half_width, height))
            # Final_file = f"Grey_Raw_image{i}.jpg"
            # Save with full output path
            Final_file = os.path.join(output_dir, f"Grey_Raw_image1.jpg")
            Final.save(Final_file)

            print("Image saved at:", Final_file)
        except Exception as e:
            print("Raw Image corrupted: {e}")


def detect_digit(image_path):

    img = cv2.imread(image_path)
    if img is None:
        raise Exception("Image not found")

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Improve contrast
    gray = cv2.equalizeHist(gray)

    # Detect edges
    edges = cv2.Canny(gray,50,150)

    # Find contours
    contours,_ = cv2.findContours(edges,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)

    card = None
    max_area = 0

    # Find the card (largest rectangle)
    for c in contours:
        area = cv2.contourArea(c)

        if area > max_area:
            x,y,w,h = cv2.boundingRect(c)

            if w > 200 and h > 150:
                max_area = area
                card = (x,y,w,h)

    if card is None:
        return None

    x,y,w,h = card
    roi = gray[y:y+h, x:x+w]

    # Threshold to isolate digit
    _, roi = cv2.threshold(roi,0,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)

    # Remove noise
    roi = cv2.medianBlur(roi,5)

    # Extract the largest contour (digit)
    contours,_ = cv2.findContours(roi,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)

    if contours:
        cnt = max(contours, key=cv2.contourArea)
        x,y,w,h = cv2.boundingRect(cnt)
        roi = roi[y:y+h, x:x+w]

    # Normalize digit size
    roi = cv2.resize(roi,DIGIT_SIZE)

    # Detect edges of digit
    digit_edges = cv2.Canny(roi,50,150)

    best_digit = None
    best_score = -1

    # Compare with templates
    for d in range(1,5):

        path = os.path.join(TEMPLATE_DIR,f"{d}.jpg")

        if not os.path.exists(path):
            continue

        template = cv2.imread(path,0)

        template = cv2.resize(template,DIGIT_SIZE)

        # Apply same preprocessing to template
        _, template = cv2.threshold(template,128,255,cv2.THRESH_BINARY_INV)

        template_edges = cv2.Canny(template,50,150)

        result = cv2.matchTemplate(
            digit_edges,
            template_edges,
            cv2.TM_CCOEFF_NORMED
        )

        score = result.max()

        if score > best_score:
            best_score = score
            best_digit = d

    return best_digit

def get_raw_resolution(image_path, width, height):
    width = int(width)
    height = int(height)
    if not os.path.exists(image_path):
        raise Exception(f"File not found: {image_path}")

    data = np.fromfile(image_path, dtype=np.uint8)

    expected_size = int(width * height * 1.5)

    if data.size != expected_size:
        raise Exception(
            f"Size mismatch! Expected {expected_size}, got {data.size}"
        )

    return width, height

def validate_video(video_path, frame_gap=30, similarity_threshold=0.98):

    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        raise AssertionError("Video cannot be opened")
    frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    if frame_count < frame_gap:
        raise AssertionError("Video too short for validation")
    #Read first frame
    cap.set(cv2.CAP_PROP_POS_FRAMES, 0)
    ret1, frame1 = cap.read()
    # Read later frame
    cap.set(cv2.CAP_PROP_POS_FRAMES, frame_gap)
    ret2, frame2 = cap.read()
    if not ret1 or not ret2:
        raise AssertionError("Unable to read frames")
    # Resize for comparison
    frame2 = cv2.resize(frame2, (frame1.shape[1], frame1.shape[0]))
    # Convert to grayscale
    gray1 = cv2.cvtColor(frame1, cv2.COLOR_BGR2GRAY)
    gray2 = cv2.cvtColor(frame2, cv2.COLOR_BGR2GRAY)
    # Check freeze (frame similarity)
    diff = cv2.absdiff(gray1, gray2)
    non_zero = np.count_nonzero(diff)
    similarity = 1 - (non_zero / diff.size)
    if similarity > similarity_threshold:
        raise AssertionError("Video appears frozen or not progressing")
    # Check black/distorted frame
    if np.mean(gray2) < 10:
        raise AssertionError("Black or distorted frame detected")
    # Check FPS (basic hang indicator)
    fps = cap.get(cv2.CAP_PROP_FPS)
    if fps == 0:
        raise AssertionError("Invalid FPS, possible corruption")
    cap.release()
    return "Video validation passed"

def validate_video_static(
    video_path,
    sample_frames=5,
    frame_gap=15,
    similarity_threshold=0.98,
    black_threshold=10,
    min_motion_frames=2,
    allow_static=True,
    return_type="detailed"   # "status" or "detailed"
):
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        raise AssertionError("Video cannot be opened")
    frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    if frame_count <= 1:
        raise AssertionError("Invalid or empty video")
    frame_gap = min(frame_gap, max(1, frame_count // (sample_frames + 1)))
    frames = []
    # ---- Frame Sampling ----
    for i in range(sample_frames):
        pos = i * frame_gap
        cap.set(cv2.CAP_PROP_POS_FRAMES, pos)
        ret, frame = cap.read()
        if not ret or frame is None:
            continue
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        frames.append(gray)
    if len(frames) < 2:
        raise AssertionError("Not enough valid frames")
    motion_count = 0
    black_frame_count = 0
    # ---- Frame Comparison ----
    for i in range(len(frames) - 1):
        f1 = frames[i]
        f2 = frames[i + 1]
        if f1.shape != f2.shape:
            f2 = cv2.resize(f2, (f1.shape[1], f1.shape[0]))
        diff = cv2.absdiff(f1, f2)
        non_zero = np.count_nonzero(diff)
        similarity = 1 - (non_zero / diff.size)
        if similarity < similarity_threshold:
            motion_count += 1
        if np.mean(f2) < black_threshold:
            black_frame_count += 1
    # ---- Classification Logic ----
    if motion_count == 0:
        video_type = "STATIC"
    elif motion_count < min_motion_frames:
        video_type = "LOW_MOTION"
    else:
        video_type = "DYNAMIC"
    # ---- Validation Rules ----
    # Frozen detection (only if motion expected)
    if video_type in ["STATIC", "LOW_MOTION"]:
        if not allow_static:
            raise AssertionError(
                f"Video appears frozen or low motion (motion_count={motion_count})"
            )
    # Distortion check
    if black_frame_count > len(frames) // 2:
        raise AssertionError(
            f"Too many black/distorted frames ({black_frame_count})"
        )
    # FPS check (soft)
    fps = cap.get(cv2.CAP_PROP_FPS)
    if fps is not None and fps < 1:
        print("Warning: Low/invalid FPS")
    cap.release()
    if return_type == "detailed":
        return {
            "status": "PASS",
            "video_type": video_type,
            "motion_count": motion_count,
            "black_frames": black_frame_count,
            "fps": fps,
            "frame_count": frame_count
        }
    else:
        return f"PASS - {video_type} video"