#!/usr/bin/python
# Test-only module for the Stackweaver E2E suite: returns a fixed marker string.
from __future__ import annotations

from ansible.module_utils.basic import AnsibleModule

DOCUMENTATION = r"""
module: e2e_marker
short_description: Return a fixed marker string
description:
  - Proves that the stackweaver.e2e collection was installed from requirements.yml.
author:
  - Stackweaver E2E suite
"""

EXAMPLES = r"""
- name: Run the marker module
  stackweaver.e2e.e2e_marker:
"""

RETURN = r"""
marker:
  description: Fixed marker string.
  returned: always
  type: str
  sample: stackweaver-e2e-collection-ok
"""


def main():
    module = AnsibleModule(argument_spec={}, supports_check_mode=True)
    module.exit_json(changed=False, marker="stackweaver-e2e-collection-ok")


if __name__ == "__main__":
    main()
