FROM golang:1.20-alpine

# Install the Certificate-Authority certificates for the app to be able to make
# calls to HTTPS endpoints.
RUN apk add --no-cache ca-certificates
RUN apk --no-cache add curl

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY sinks ./sinks
COPY *.go ./
RUN go build -o /eventrouter

# Perform all further action as an unprivileged user.
USER 65535:65535

ENTRYPOINT ["/eventrouter"]