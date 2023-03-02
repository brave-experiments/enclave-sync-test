FROM public.ecr.aws/eks-distro-build-tooling/golang:1.20 as builder

WORKDIR /src/
RUN git clone -b query-dns-srv https://github.com/brave/nitriding
RUN make -C nitriding/cmd nitriding

FROM public.ecr.aws/docker/library/alpine:latest

RUN apk update && apk add curl

COPY --from=builder /src/nitriding/cmd/nitriding /usr/bin/
COPY start.sh /usr/bin/

CMD ["start.sh"]
