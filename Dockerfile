ARG PYTHON_VERSION="3.8"

FROM public.ecr.aws/lambda/python:${PYTHON_VERSION} AS base

FROM base AS build-image

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" 

COPY . .
RUN python3 -m pip install -r requirements.txt

FROM base

COPY --from=build-image /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY --from=build-image /var/task/heracles ./heracles

CMD [ "heracles.lambda.handler" ]
