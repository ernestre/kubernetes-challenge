# kubernetes-challenge

# Install Elastic chart
Follow instructions in [the official documentation](https://github.com/elastic/helm-charts/blob/main/elasticsearch/README.md).

* add elastic serach security

# ELK moves:
* helm upgrade elasticsearch elastic/elasticsearch -f es_values.yml --install
* helm upgrade --install kibana elastic/kibana


# fluentbit
* helm repo add fluent https://fluent.github.io/helm-charts
helm upgrade --install fluent-bit fluent/fluent-bit -f fluentbit_values.yml