provider "aws" {
  region     = "eu-central-1"
}

resource "aws_iam_policy" "allow_user_to_manage_their_mfa" {
  name        = "allow-user-to-manage-their-mfa"
  path        = "/"
  description = "Allow users to manage mult-factor auth devices on their own account"

  policy = <<EOF
{ 
"Version": "2012-10-17", 
"Statement": [ 
{ 
"Sid": "AllowUsersToCreateEnableResyncDeleteTheirOwnVirtualMFADevice", 
"Effect": "Allow", 
"Action": [ 
"iam:CreateVirtualMFADevice", 
"iam:EnableMFADevice", 
"iam:ResyncMFADevice", 
"iam:DeleteVirtualMFADevice" 
], 
"Resource": [ 
"arn:aws:iam::**********:mfa/$${aws:username}", 
"arn:aws:iam::***********:user/$${aws:username}" 
] 
}, 
{ 
"Sid": "AllowUsersToDeactivateTheirOwnVirtualMFADevice", 
"Effect": "Allow", 
"Action": [ 
"iam:DeactivateMFADevice" 
], 
"Resource": [ 
"arn:aws:iam::***********:mfa/$${aws:username}", 
"arn:aws:iam::*********:user/$${aws:username}" 
], 
"Condition": { 
"Bool": { 
"aws:MultiFactorAuthPresent": true 
} 
} 
}, 
{ 
"Sid": "AllowUsersToListMFADevicesandUsersForConsole", 
"Effect": "Allow", 
"Action": [ 
"iam:ListMFADevices", 
"iam:ListVirtualMFADevices", 
"iam:ListUsers" 
], 
"Resource": "*" 
} 
] 
} 
EOF
}
