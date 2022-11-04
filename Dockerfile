FROM confluentinc/cp-kafka:7.2.2.arm64

COPY run-command.sh run-command.sh

CMD ["bash", "run-command.sh"]
