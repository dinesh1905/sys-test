from robocop.checkers import VisitorChecker
from robocop.rules import Rule, RuleSeverity

rules = {
    "3001": Rule(rule_id="3001", name="missing-TCID-tag", msg="Each test case must have a TCID tag (e.g., 'TCID-123456').", severity=RuleSeverity.ERROR),
    "3003": Rule(rule_id="3003", name="missing-FID-tag", msg="Each test case must have a FID tag (e.g., 'FID-1234567').", severity=RuleSeverity.ERROR),
    "3004": Rule(rule_id="3004", name="missing-tags-setting", msg="Each test case must have a [Tags] setting defined.", severity=RuleSeverity.ERROR),
    "3006": Rule(rule_id="3006", name="test-case-name-prefix", msg="Test case name must start with 'EnvD_'.", severity=RuleSeverity.ERROR),
    "3007": Rule(rule_id="3007", name="incorrect-underscore-count", msg="please follow naming convention [Blade/Rack]_[Test Level]_[Component]_[Subcomponent]_[Logical name]", severity=RuleSeverity.ERROR),
    "3008": Rule(rule_id="3008", name="invalid-fid-format", msg="FID number must be exactly 7 digits.", severity=RuleSeverity.ERROR),
    "3009": Rule(rule_id="3009", name="invalid-tcid-format", msg="TCID number must be exactly 6 digits.", severity=RuleSeverity.ERROR),
    "3010": Rule(rule_id="3010", name="missing-category-tag", msg="Missing category tag. Must include one of: POWER, CUSTOMERDIAGNOSTIC, COMMUNICATION, SAFETY, SOC, MEMORY, MCU, DISPLAY.", severity=RuleSeverity.ERROR),
    "3011": Rule(rule_id="3011", name="missing-documentation", msg="Test case is missing [Documentation].", severity=RuleSeverity.ERROR),
    "3012": Rule(rule_id="3012", name="missing-metadata-project", msg="Suite is missing 'Metadata    project' setting.", severity=RuleSeverity.ERROR),
    "3013": Rule(rule_id="3013", name="missing-metadata-version-sw", msg="Suite is missing 'Metadata    version_sw' setting.", severity=RuleSeverity.ERROR),
    "3014": Rule(rule_id="3014", name="missing-metadata-team-area", msg="Suite is missing 'Metadata    team-area' setting.", severity=RuleSeverity.ERROR)
}

class TestCaseChecker(VisitorChecker):
    reports = (
        "missing-TCID-tag", "missing-FID-tag", "missing-tags-setting",
        "test-case-name-prefix", "incorrect-underscore-count",
        "invalid-fid-format", "invalid-tcid-format", "missing-category-tag",
        "missing-documentation"
    )

    max_underscores = 4

    def visit_TestCase(self, node):
        if not node.name.startswith("EnvD_"):
            self.report("test-case-name-prefix", node=node)

        if node.name.count('_') != int(self.max_underscores):
            self.report("incorrect-underscore-count", node=node)

        tags_statement = None
        doc_statement = None
        for statement in node.body:
            if hasattr(statement, 'type'):
                if statement.type == 'TAGS':
                    tags_statement = statement
                elif statement.type == 'DOCUMENTATION':
                    doc_statement = statement
        
        if doc_statement is None:
            self.report("missing-documentation", node=node)

        if tags_statement is None:
            self.report("missing-tags-setting", node=node)
            return

        tags = {t.upper() for t in tags_statement.values}
        tcid_found = False
        fid_found = False

        category_tags = {"POWER", "CUSTOMERDIAGNOSTIC", "COMMUNICATION", "SAFETY", "SOC", "MEMORY", "MCU", "DISPLAY"}
        if not category_tags.intersection(tags):
            self.report("missing-category-tag", node=node)

        for tag in tags:
            if tag.startswith("TCID-"):
                tcid_found = True
                number_part = tag[5:]
                if not (number_part.isdigit() and len(number_part) == 6):
                    self.report("invalid-tcid-format", node=node)

            if tag.startswith("FID-"):
                fid_found = True
                numbers_part = tag[4:]
                individual_fids = numbers_part.split(',')
                for fid_number in individual_fids:
                    if not (fid_number.isdigit() and len(fid_number) == 7):
                        self.report("invalid-fid-format", node=node)
                        break

        if not tcid_found:
            self.report("missing-TCID-tag", node=node)
        if not fid_found:
            self.report("missing-FID-tag", node=node)


class SuiteMetadataChecker(VisitorChecker):
    reports = (
        "missing-metadata-project",
        "missing-metadata-version-sw",
        "missing-metadata-team-area"
    )

    def visit_SettingSection(self, node):
        metadata_keys = set()
        for statement in node.body:
            if hasattr(statement, 'type') and statement.type == 'METADATA':
                if hasattr(statement, 'name') and statement.name:
                    metadata_keys.add(statement.name.lower())

        if "project" not in metadata_keys:
            self.report("missing-metadata-project", node=node)
        if "version_sw" not in metadata_keys:
            self.report("missing-metadata-version-sw", node=node)
        if "team-area" not in metadata_keys:
            self.report("missing-metadata-team-area", node=node)
