locals {
  elasticsearch_vars = {
    "TAMR_ES_ENABLED": var.es_domain_endpoint!="",
    "TAMR_REMOTE_ES_ENABLED": var.es_domain_endpoint!="",
    "TAMR_ES_SSL_ENABLED": var.es_domain_endpoint!="",
    "TAMR_ES_APIHOST": var.es_domain_endpoint!="" ? "${var.es_domain_endpoint}:443" : "localhost:9200"
  }
}
