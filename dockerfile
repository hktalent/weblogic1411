FROM weblogic1411
# RUN "su - weblogic;"
USER weblogic

# weblogic/weblogic123
EXPOSE 7001

ENTRYPOINT ["/home/weblogic/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain/startWebLogic.sh"]
