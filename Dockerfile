ARG RUBY_VERSION
ARG REDMINE_VERSION
FROM twopackas/redmine-test-image:${REDMINE_VERSION}_ruby${RUBY_VERSION}

COPY lib/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
