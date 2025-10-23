FROM docker.io/hashicorp/terraform:1.13.4@sha256:eebc943e69008b6d6d986800087164274d8c92d83db8d53fb9baa4ccff309884 AS terraform
FROM docker.io/cytopia/terraform-docs:0.20.0@sha256:c1b894923ac72e64780d9464245090c98cb3800e9c98c36181d32d9c49d3a30c AS terraform-docs

FROM python:3.14.0rc3-slim-trixie@sha256:e1bb3adc44d158b8b37d647dbfa5864b74f387552c5f12abe9cc95ae773b7c69 AS build

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --upgrade pip
RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pre-commit

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=terraform /bin/terraform /usr/local/bin/terraform
COPY --from=terraform-docs /usr/local/bin/terraform-docs /usr/local/bin/terraform-docs

#FROM gcr.io/distroless/python3-debian12:nonroot

#COPY --from=build /opt/venv /opt/venv

#ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

ENTRYPOINT ["pre-commit"]
