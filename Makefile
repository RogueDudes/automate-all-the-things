BIN_PATH := bin
VENDOR_PATH := vendor

PREREQUISITES := \
	gem:RugyGems:http://guides.rubygems.org \
	bundle:Bundler:http://bundler.io/ \
	VBoxManage:VirtualBox:https://www.virtualbox.org/wiki/Downloads \
	ansible-playbook:Ansible:http://docs.ansible.com/intro_installation.html \

ECHO := printf

.PHONY: install verify-prerequisites vagrant-up bundle-install

install: vagrant-up
	@$(ECHO) 'The machine is created. To provision it run `make ansible` or `make puppet`.'

ansible: vagrant-up
	@$(VAGRANT_BIN) provision --provision-with=ansible

puppet: vagrant-up
	@$(VAGRANT_BIN) provision --provision-with=puppet

# Vagrant is not happy when its running from source.
# By overriding the environment, we can trick it to suppress warning messages.
VAGRANT_BIN := '$(BIN_PATH)/vagrant'

# Bring up the virtual machine if it doesn't already exist.
vagrant-up: verify-prerequisites bundle-install
	@$(VAGRANT_BIN) up --no-provision

verify-prerequisites:
	@$(foreach PREREQUISITE,$(PREREQUISITES), \
		$(eval PREREQUISITE_CMD := $(word 1,$(subst :, ,$(PREREQUISITE)))) \
		$(eval PREREQUISITE_NAME := $(word 2,$(subst :, ,$(PREREQUISITE)))) \
		$(eval PREREQUISITE_URL := $(word 3,$(subst :, ,$(PREREQUISITE)))) \
		\
		$(ECHO) "Checking if $(subst _, ,$(PREREQUISITE_NAME)) is available... " ; \
		if which $(PREREQUISITE_CMD) 1>/dev/null 2>&1 ; then \
			which $(PREREQUISITE_CMD) ; \
		else \
			$(ECHO) 'no.\n\n' ; \
			$(ECHO) '\tThe command "$(PREREQUISITE_CMD)" is not installed.\n\n' ; \
			$(ECHO) '\tVisit $(PREREQUISITE_URL) for instructions.\n\n' ; \
			exit 1 ; \
		fi ; \
	)

# Install or update RugyGem dependencies.
bundle-install:
	@$(ECHO) 'Updating RubyGem dependencies in "$(VENDOR_PATH)"...\n'
	@bundle install --path '$(VENDOR_PATH)' --binstubs '$(BIN_PATH)'

# Install 3rd-party modules for the Puppet provisioning.
puppet-deps: bundle-install
	@$(ECHO) 'Install Puppet 3rd-party modules in "$(VENDOR_PATH)... \n'
	@bundle exec librarian-puppet install


# vi: set ft=make ts=4 sts=4 sw=4 noet :
