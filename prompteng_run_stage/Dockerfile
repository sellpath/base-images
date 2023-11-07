FROM gosellpath/python_run_stage:2023110602  as python-run-stage

# PromptEng specific requirements are too large to export and import again
# just install and use
COPY prompteng_run_stage_requirements.txt ./requirements.txt

RUN pip install -r requirements.txt
RUN rm requirements.txt
