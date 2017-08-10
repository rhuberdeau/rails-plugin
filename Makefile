test:
	RAILS_ENV=test \
	TB_API_KEY=example_key TB_PROPERTY_ID=example_property_id \
	bundle exec rake -t

# example: make release V=0.0.0
release:
	git tag v$(V)
	@read -p "Press enter to confirm and push to origin ..." && git push origin v$(V)

.PHONY: test release
