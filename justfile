default:
  @just --list

apply-all: foundation platform applications

foundation:
  cd 01_foundation/ && terraform apply -auto-approve

@refresh: foundation

platform: refresh
  cd 02_platform/ && terraform apply -auto-approve

applications: refresh
  cd 03_applications && terraform apply -auto-approve

# TODO: Split data and workload to allow proper suspend
suspend:
  cd 03_applications/ && \
    terraform destroy -auto-approve

  cd 02_platform/ && \
    terraform destroy -auto-approve

resume:
  cd 02_platform/ && \
    terraform apply -auto-approve

  cd 03_applications/ && \
    terraform apply -auto-approve
