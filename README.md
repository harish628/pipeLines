Automated PipeLines for Different Usecases
Install git.
Add the jenkins user to root user, using below commands.
  sudo visudo
  jenkins ALL=(ALL) NOPASSWD: ALL
  sudo -u jenkins sudo whoami
    Expected O/p: root
  systemctl restart jenkins
Provide AWS Authentication Token to credentials
  Install the AWS Steps plugin
  Manage Jenkins → Credentials --> Add credentials --> Kind: AWS Credentials --> Provide Access key & Security Access key secret.
To switch to jenkins user
   sudo -u jenkins /bin/bash
