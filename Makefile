##############
# parameters #
##############
# do dependency on the makefile itself?
DO_ALLDEP:=1
# do you want to see the commands executed ?
DO_MKDBG:=0
# do you want to lint perl files?
DO_LINT:=1

########
# code #
########
# silent stuff
ifeq ($(DO_MKDBG),1)
Q:=
# we are not silent in this branch
else # DO_MKDBG
Q:=@
#.SILENT:
endif # DO_MKDBG

ifeq ($(DO_ALLDEP),1)
.EXTRA_PREREQS+=$(foreach mk, ${MAKEFILE_LIST},$(abspath ${mk}))
endif # DO_ALLDEP

ALL:=
ALL_PL:=$(shell find src -name "*.pl")
ALL_LINT:=$(addprefix out/,$(addsuffix .lint, $(basename $(ALL_PL))))

ifeq ($(DO_LINT),1)
ALL+=$(ALL_LINT)
endif # DO_LINT

#########
# rules #
#########
.PHONY: all
all: $(ALL)
	@true

.PHONY: install
install:
	$(Q)pymakehelper symlink_install --source_folder src --target_folder ~/install/bin

.PHONY: debug
debug:
	$(info ALL_PL is $(ALL_PL))
	$(info ALL_LINT is $(ALL_LINT))

############
# patterns #
############
$(ALL_LINT): out/%.lint: %.pl
	$(info doing [$@])
	$(Q)pymakehelper only_print_on_error perl -Mstrict -Mdiagnostics -cw $<
	$(Q)pymakehelper only_print_on_error perl -MO=Lint $<
	$(Q)pymakehelper touch_mkdir $@
