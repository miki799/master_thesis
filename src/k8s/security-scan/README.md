# README

## kube-bench

#### Installation

`su -`

`curl -LO https://github.com/aquasecurity/kube-bench/releases/download/v0.7.3/kube-bench_0.7.3_linux_arm64.tar.gz`

`mkdir -p /etc/kube-bench`

`tar -xvf kube-bench_0.7.3_linux_arm64.tar.gz -C /etc/kube-bench`

`mv /etc/kube-bench/kube-bench /usr/local/bin`

###### One liner

`su -c 'curl -LO https://github.com/aquasecurity/kube-bench/releases/download/v0.7.3/kube-bench_0.7.3_linux_arm64.tar.gz && mkdir -p /etc/kube-bench && tar -xvf kube-bench_0.7.3_linux_arm64.tar.gz -C /etc/kube-bench && mv /etc/kube-bench/kube-bench /usr/local/bin'`


#### How to run?

###### Worker

`mkdir kube-bench-logs && kube-bench run -v 5 --targets=node > kube-bench-logs/kube-bench-$(date '+%Y-%m-%d_%H-%M-%S')_logs.txt`

###### Control plane

`kube-bench run -v 5 --targets=master > kube-bench-logs.txt`

## kube-bench

#### How to run?