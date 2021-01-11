<p align="center">
    <img  alg="Eclipx" src="http://eclipxgroup.com/wp-content/themes/reverie-master/img/template/eclipx-group-logo.png" />
</p>


# Goal

Attached is a simple Node.js web app with 2 files
1. package.json
2. server.js

Create a Dockerfile and the relevant file(s) so we could build the docker image and deploy it onto GCP or a cloud environment of your choice.

# Criteria

1. From the 2 supplied files, create a Dockerfile and relevant instructions so we could build the docker image.
2. Supply the relevant terraform scripts for the creation of the cloud project and other necessary steps for deployment.
3. Scripts to deploy the docker image.


# Acceptance Criteria

1. Dockerfile so an image from built 
2. Terraform scripts to create the cloud project for deployment.
3. Deployment scripts
4. Steps are documented and easy to follow.


# Bonus Points

- Extra steps to productionise the image eg image tagging/ versioning
- Adapting stronger Security Practices
- Multistage build


# Steps to Run

1. Update AWS_ACCOUNT_ID variable in Makefile with the your account ID
2. Run the below steps
    - make terraform-init
    - make terraform-plan
    - make terraform-apply
    - make dockerBuild
    - make dockerPush
    - make deploy-ecs