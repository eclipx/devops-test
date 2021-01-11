echo ""
echo "---> Registering Task Definition"

# Update the ECS service to use the updated Task version

TASK_ARN=$(aws ecs register-task-definition \
  --cli-input-json task-defination.json\
  --query="taskDefinition.taskDefinitionArn" \
  --output=text)

echo "---> Updating ECS Service"
echo "       CLUSTER_NAME: ${CLUSTER_NAME}"
echo "       APP_NAME: ${APP_NAME}"
echo "       TASK_ARN: ${TASK_ARN}"

aws ecs update-service \
  --cluster $CLUSTER_NAME \
  --service $APP_NAME \
  --task-definition $TASK_ARN

RET=$?

if [ $RET -eq 0 ]; then
  echo "---> Deployment completed!"
else
  echo "---> ERROR: Deployment FAILED!"
fi

exit $RET