terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

module "main" {
  source = "../.."

  name          = "LEAF105"
  node_id       = 105
  pod_id        = 2
  serial_number = "ABCDEFGHIJKLMN"
  type          = "tier-2-leaf"
}

data "aci_rest_managed" "fabricNodeIdentP" {
  dn = "uni/controller/nodeidentpol/nodep-ABCDEFGHIJKLMN"

  depends_on = [module.main]
}

resource "test_assertions" "fabricNodeIdentP" {
  component = "fabricNodeIdentP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricNodeIdentP.content.name
    want        = "LEAF105"
  }

  equal "nodeId" {
    description = "nodeId"
    got         = data.aci_rest_managed.fabricNodeIdentP.content.nodeId
    want        = "105"
  }

  equal "serial" {
    description = "serial"
    got         = data.aci_rest_managed.fabricNodeIdentP.content.serial
    want        = "ABCDEFGHIJKLMN"
  }

  equal "nodeType" {
    description = "nodeType"
    got         = data.aci_rest_managed.fabricNodeIdentP.content.nodeType
    want        = "tier-2-leaf"
  }

  equal "podId" {
    description = "podId"
    got         = data.aci_rest_managed.fabricNodeIdentP.content.podId
    want        = "2"
  }
}
