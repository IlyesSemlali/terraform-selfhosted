default:
  @just --list

# deploy the entire stack
apply-all: foundation platform applications

# build foundation
foundation:
  cd 01_foundation/ && terraform apply -auto-approve

@refresh: foundation

# deploy platform
platform: refresh
  cd 02_platform/ && terraform apply -auto-approve

# deploy applications
applications: refresh
  cd 03_applications && terraform apply -auto-approve

# TODO: Split data and workload to allow proper suspend

# suspend workloads
suspend:
  cd 03_applications/ && \
    terraform destroy -auto-approve

  cd 02_platform/ && \
    terraform destroy -auto-approve

# resume workloads
resume:
  cd 02_platform/ && \
    terraform apply -auto-approve

  cd 03_applications/ && \
    terraform apply -auto-approve
