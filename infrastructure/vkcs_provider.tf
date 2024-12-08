terraform {
    required_providers {
        vkcs = {
            source = "vk-cs/vkcs"
            version = "~> 0.8.0"
        }
    }
}

terraform {
    backend "s3" {
        bucket     = "tfstate-bucket"
        key        = "terraform.tfstate"
        region     = "kz-ast"
        access_key = "r6jGYjkkMFkgh4mk2F6LkV"
        secret_key = "eW4kyMooFJD3UzH7Zy7Cz23tYyvQgPxbn7v9vTCY88FR"

        skip_credentials_validation = true
        skip_metadata_api_check     = true
        skip_requesting_account_id  = true
        skip_region_validation      = true
        skip_s3_checksum            = true
        endpoints = {
            s3 = "https://hb.kz-ast.bizmrg.com"
        }
    }
}

provider "vkcs" {
    # Your user account.
    username = "tezapp.kz@gmail.com"

    # The password of the account
    password = "R*cP@8wN"

    # The tenant token can be taken from the project Settings tab - > API keys.
    # Project ID will be our token.
    project_id = "207aceabc05f430db9436dae26f51336"

    # Region name
    region = "kz"
    
    auth_url = "https://kz.infra.mail.ru:35357/v3/" 
}
