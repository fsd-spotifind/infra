This is the infrastructure repository for our Spotifind Project.

GitHub: [link](https://github.com/fsd-spotifind/infra

This project uses Terraform CLI-driven workflows, run from our GitHub Actions pipelines (One for Plan - to be run for PRs on all branches and one for Apply - run on merge from main)

Ensure that you have your Terraform Cloud account set up. We use this for remote infrastructure state tracking.

## Set up AWS account 
1. Create Identity Providers in AWS
We will need:
- `token.actions.githubusercontent.com`
- `app.terraform.io`

2. Create the Terraform Deploy Role
Attach the following permissions:
ECR: <pre> <code>```json { "Version": "2012-10-17", "Statement": [ { "Sid": "VisualEditor0", "Effect": "Allow", "Action": [ "ecr:CreateRepository", "ecr:TagResource", "ecr:DeleteRepository", "ecr:DescribeRepositories", "ecr:ListTagsForResource", "ecr:GetLifecyclePolicy", "ecr:GetLifecyclePolicyPreview", "ecr:DeleteLifecyclePolicy", "ecr:PutLifecyclePolicy", "ecr:DescribeImages" ], "Resource": "*" } ] } ```</code> </pre>

IAM: <pre> <code>```json { "Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Action": [ "iam:CreatePolicy", "iam:CreatePolicyVersion", "iam:GetPolicy", "iam:GetPolicyVersion", "iam:ListPolicies", "iam:ListPolicyVersions", "iam:ListPolicyTags", "iam:DeletePolicy", "iam:DeletePolicyVersion", "iam:CreateRole", "iam:ListInstanceProfilesForRole", "iam:ListAttachedRolePolicies", "iam:ListRolePolicies", "iam:DeleteRole", "iam:PutRolePolicy", "iam:GetRole", "iam:GetRolePolicy", "iam:CreateInstanceProfile", "iam:GetInstanceProfile", "iam:DeleteInstanceProfile", "iam:AddRoleToInstanceProfile", "iam:PassRole", "iam:CreateServiceLinkedRole", "iam:DeleteServiceLinkedRole", "iam:AttachRolePolicy", "iam:ListEntitiesForPolicy", "iam:DetachRolePolicy" ], "Resource": "*" } ] } ```</code> </pre>

autoscaling: <pre> <code>```json { "Version": "2012-10-17", "Statement": [ { "Sid": "autoscalingPermissions", "Effect": "Allow", "Action": [ "autoscaling:CreateAutoScalingGroup", "autoscaling:DeleteAutoScalingGroup", "autoscaling:TerminateInstanceInAutoScalingGroup", "autoscaling:UpdateAutoScalingGroup", "autoscaling:DescribeScalingActivities", "autoscaling:DescribeAutoScalingGroups", "autoscaling:EnableMetricsCollection", "autoscaling:DisableMetricsCollection" ], "Resource": "*" } ] } ```</code> </pre>

ec2: <pre> <code>```json { "Version": "2012-10-17", "Statement": [ { "Sid": "ec2Permissions", "Effect": "Allow", "Action": [ "ec2:RunInstances", "ec2:DescribeInstances", "ec2:DescribeImages", "ec2:DescribeKeyPairs", "ec2:DescribeSecurityGroups", "ec2:DescribeSubnets", "ec2:DescribeVpcs", "ec2:StartInstances", "ec2:StopInstances", "ec2:TerminateInstances", "ec2:RebootInstances", "ec2:CreateVpc", "ec2:CreateTags", "ec2:ModifyVpcAttribute", "ec2:DescribeVpcAttribute", "ec2:DeleteVpc", "ec2:CreateInternetGateway", "ec2:CreateSubnet", "ec2:AttachInternetGateway", "ec2:ModifySubnetAttribute", "ec2:DescribeInternetGateways", "ec2:DescribeNetworkInterfaces", "ec2:DeleteInternetGateway", "ec2:DeleteSubnet", "ec2:CreateRouteTable", "ec2:DescribeRouteTables", "ec2:CreateRoute", "ec2:CreateSecurityGroup", "ec2:DeleteRouteTable", "ec2:RevokeSecurityGroupEgress", "ec2:DeleteSecurityGroup", "ec2:AssociateRouteTable", "ec2:AuthorizeSecurityGroupIngress", "ec2:AuthorizeSecurityGroupEgress", "ec2:CreateNetworkInterface", "ec2:ModifyNetworkInterfaceAttribute", "ec2:DeleteNetworkInterface", "ec2:CreateLaunchTemplate", "ec2:DescribeLaunchTemplates", "ec2:DeleteLaunchTemplate", "ec2:ModifyLaunchTemplate", "ec2:DescribeLaunchTemplateVersions", "ec2:DetachNetworkInterface", "ec2:DisassociateRouteTable", "ec2:CreateLaunchTemplateVersion", "ec2:DescribeAccountAttributes", "ec2:RevokeSecurityGroupIngress" ], "Resource": [ "*" ] } ] } ```</code> </pre>

ecs: <pre> <code>```json { "Version": "2012-10-17", "Statement": [ { "Sid": "addECSPermissions", "Effect": "Allow", "Action": [ "ecs:CreateCluster", "ecs:RegisterTaskDefinition", "ecs:DescribeClusters", "ecs:DeleteCluster", "ecs:DescribeTaskDefinition", "ecs:ListTaskDefinitions", "ecs:DeregisterTaskDefinition", "ecs:CreateService", "ecs:UpdateService", "ecs:DeleteService" ], "Resource": [ "*" ] } ] } ```</code> </pre>

lb: <pre> <code>```json { "Version": "2012-10-17", "Statement": [ { "Sid": "addLBPermissions", "Effect": "Allow", "Action": [ "elasticloadbalancing:CreateTargetGroup", "elasticloadbalancing:ModifyTargetGroupAttributes", "elasticloadbalancing:DescribeTargetGroupAttributes", "elasticloadbalancing:DescribeTags", "elasticloadbalancing:DeleteTargetGroup", "elasticloadbalancing:DescribeLoadBalancers", "elasticloadbalancing:CreateLoadBalancer", "elasticloadbalancing:ModifyLoadBalancerAttributes", "elasticloadbalancing:DescribeLoadBalancerAttributes", "elasticloadbalancing:DeleteLoadBalancer", "elasticloadbalancing:CreateListener", "elasticloadbalancing:ModifyListenerAttributes", "elasticloadbalancing:DescribeListenerAttributes", "elasticloadbalancing:DeleteListener", "elasticloadbalancing:ModifyTargetGroup", "acm:ImportCertificate", "acm:ListCertificates", "acm:DescribeCertificate", "acm:GetCertificate", "acm:AddTagsToCertificate", "acm:RemoveTagsFromCertificate", "acm:ListTagsForCertificate", "acm:DeleteCertificate", "acm:RequestCertificate" ], "Resource": [ "*" ] } ] } ```</code> </pre>

logs: <pre> <code>```json { "Version": "2012-10-17", "Statement": [ { "Sid": "Statement1", "Effect": "Allow", "Action": [ "logs:CreateLogGroup", "logs:DescribeLogGroups", "logs:DeleteLogGroup", "logs:PutRetentionPolicy", "logs:DeleteRetentionPolicy", "logs:ListTagsForResource" ], "Resource": [ "*" ] } ] } ```</code> </pre>

ssm: <pre> <code>```json { "Version": "2012-10-17", "Statement": [ { "Sid": "ssmPermissions", "Effect": "Allow", "Action": [ "ssm:PutParameter", "ssm:GetParameter", "ssm:DescribeParameters", "ssm:ListTagsForResource", "ssm:GetParameters", "ssm:DeleteParameter" ], "Resource": [ "*" ] } ] } ```</code> </pre>

Managed Policies
- AWSCodeDeployRoleForECS
- EC2InstanceProfileForImageBuilderECRContainerBuilds

3. Copy the ARN for the above Role

## Setting up Repositories
1. For GitHub:
Repository Secrets:
- AWS_ROLE_ARN - the ARN we copied from the previous step
- TFE_TOKEN - token to be generated from your Terraform Cloud
- DATABASE_URL_PROD/DIRECT_URL_PROD - Supabase URLs

2. For Terraform Cloud:
- TFC_AWS_RUN_ROLE_ARN - the ARN we copied from the previous step
- TFC_AWS_PROVIDER_AUTH - true
- database_url - the DATABASE_URL_PROD value
- jwt_secret
- port - 8080
- spotify_client_id
- spotify_client_secret

## Initialising the Application and Infrastructure
1. Manually trigger a run of the Terraform Apply step from main branch. This will load up all the AWS assets in your account, except your ECS Fargate for the backend..

2. From the `server` repository, run the workflow in that repository to push the files to ECR. Check that you have set the ROLE_TO_ASSUME variable in that repository, as well as the appropriate AWS_REGION and ECR_REPOSITORY env variables in the pipeline according to your infrastructure settings.

3. Rerun the Apply workflow, this will now pull the image from the ECR and spin up your ECS Cluster and Tasks. (This is only required for the intial creation of the application in your AWS environment.)