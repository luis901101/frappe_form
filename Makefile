generate-code:
# 	rm -rf .dart_tool/build
	dart run build_runner build --delete-conflicting-outputs

push:
	git push -u origin --all

format:
	dart format .

fix:
	dart fix --apply

check-publish:
	dart pub publish --dry-run

publish:
	dart pub publish

.PHONY: generate-exports
generate-exports:
	@./generate-exports