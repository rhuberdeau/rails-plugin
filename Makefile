test:
	RAILS_ENV=test \
	TB_API_KEY=example_key TB_PROPERTY_ID=example_property_id \
	rake test

.PHONY: test
