/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  version = "~> 3.5"
}

provider "google-beta" {
  version = "~> 3.5"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_id" "name" {
  byte_length = 2
}


locals {
  /*
    Random instance name needed because:
    "You cannot reuse an instance name for up to a week after you have deleted an instance."
    See https://cloud.google.com/sql/docs/mysql/delete-instance for details.
  */
  instance_name = "${var.db_name}-${random_id.name.hex}"
}

module "postgresql-db" {
  source           = "../../modules/postgresql"
  name             = local.instance_name
  database_version = "POSTGRES_9_6"
  project_id       = var.project_id
  zone             = "c"
  region           = "us-central1"
  tier             = "db-f1-micro"

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    authorized_networks = var.authorized_networks
  }
}
