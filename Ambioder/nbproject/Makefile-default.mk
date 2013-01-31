#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=cof
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Ambioder.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Ambioder.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/main.o ${OBJECTDIR}/pwm.o ${OBJECTDIR}/uart_rx.o ${OBJECTDIR}/uart_tx.o ${OBJECTDIR}/isr.o ${OBJECTDIR}/iolatch.o ${OBJECTDIR}/boot.o
POSSIBLE_DEPFILES=${OBJECTDIR}/main.o.d ${OBJECTDIR}/pwm.o.d ${OBJECTDIR}/uart_rx.o.d ${OBJECTDIR}/uart_tx.o.d ${OBJECTDIR}/isr.o.d ${OBJECTDIR}/iolatch.o.d ${OBJECTDIR}/boot.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/main.o ${OBJECTDIR}/pwm.o ${OBJECTDIR}/uart_rx.o ${OBJECTDIR}/uart_tx.o ${OBJECTDIR}/isr.o ${OBJECTDIR}/iolatch.o ${OBJECTDIR}/boot.o


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/Ambioder.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=16f684
MP_LINKER_DEBUG_OPTION=
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/main.o: main.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/main.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/main.lst\\\" -e\\\"${OBJECTDIR}/main.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/main.o\\\" \\\"main.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/main.o"
	
${OBJECTDIR}/pwm.o: pwm.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/pwm.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/pwm.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/pwm.lst\\\" -e\\\"${OBJECTDIR}/pwm.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/pwm.o\\\" \\\"pwm.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/pwm.o"
	
${OBJECTDIR}/uart_rx.o: uart_rx.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/uart_rx.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/uart_rx.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/uart_rx.lst\\\" -e\\\"${OBJECTDIR}/uart_rx.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/uart_rx.o\\\" \\\"uart_rx.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/uart_rx.o"
	
${OBJECTDIR}/uart_tx.o: uart_tx.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/uart_tx.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/uart_tx.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/uart_tx.lst\\\" -e\\\"${OBJECTDIR}/uart_tx.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/uart_tx.o\\\" \\\"uart_tx.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/uart_tx.o"
	
${OBJECTDIR}/isr.o: isr.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/isr.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/isr.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/isr.lst\\\" -e\\\"${OBJECTDIR}/isr.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/isr.o\\\" \\\"isr.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/isr.o"
	
${OBJECTDIR}/iolatch.o: iolatch.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/iolatch.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/iolatch.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/iolatch.lst\\\" -e\\\"${OBJECTDIR}/iolatch.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/iolatch.o\\\" \\\"iolatch.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/iolatch.o"
	
${OBJECTDIR}/boot.o: boot.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/boot.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/boot.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/boot.lst\\\" -e\\\"${OBJECTDIR}/boot.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/boot.o\\\" \\\"boot.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/boot.o"
	
else
${OBJECTDIR}/main.o: main.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/main.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/main.lst\\\" -e\\\"${OBJECTDIR}/main.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/main.o\\\" \\\"main.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/main.o"
	
${OBJECTDIR}/pwm.o: pwm.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/pwm.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/pwm.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/pwm.lst\\\" -e\\\"${OBJECTDIR}/pwm.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/pwm.o\\\" \\\"pwm.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/pwm.o"
	
${OBJECTDIR}/uart_rx.o: uart_rx.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/uart_rx.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/uart_rx.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/uart_rx.lst\\\" -e\\\"${OBJECTDIR}/uart_rx.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/uart_rx.o\\\" \\\"uart_rx.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/uart_rx.o"
	
${OBJECTDIR}/uart_tx.o: uart_tx.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/uart_tx.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/uart_tx.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/uart_tx.lst\\\" -e\\\"${OBJECTDIR}/uart_tx.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/uart_tx.o\\\" \\\"uart_tx.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/uart_tx.o"
	
${OBJECTDIR}/isr.o: isr.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/isr.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/isr.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/isr.lst\\\" -e\\\"${OBJECTDIR}/isr.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/isr.o\\\" \\\"isr.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/isr.o"
	
${OBJECTDIR}/iolatch.o: iolatch.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/iolatch.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/iolatch.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/iolatch.lst\\\" -e\\\"${OBJECTDIR}/iolatch.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/iolatch.o\\\" \\\"iolatch.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/iolatch.o"
	
${OBJECTDIR}/boot.o: boot.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/boot.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/boot.err" $(SILENT) -rsi ${MP_AS_DIR}  -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/boot.lst\\\" -e\\\"${OBJECTDIR}/boot.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/boot.o\\\" \\\"boot.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/boot.o"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/Ambioder.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    16f684_g.lkr
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE) "16f684_g.lkr"  -p$(MP_PROCESSOR_OPTION)  -w -x -u_DEBUG -z__ICD2RAM=1    -z__MPLAB_BUILD=1  -z__MPLAB_DEBUG=1 $(MP_LINKER_DEBUG_OPTION) -odist/${CND_CONF}/${IMAGE_TYPE}/Ambioder.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/Ambioder.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   16f684_g.lkr
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE) "16f684_g.lkr"  -p$(MP_PROCESSOR_OPTION)  -w     -z__MPLAB_BUILD=1  -odist/${CND_CONF}/${IMAGE_TYPE}/Ambioder.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell "${PATH_TO_IDE_BIN}"mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
