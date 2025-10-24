pipeline {
  agent any

  environment {
    TF_VERSION = '1.6.0'
    TERRAFORM_COMPLIANCE_VERSION = '1.13.0'
    PATH = "/var/lib/jenkins/.local/bin:$PATH"
  }

  stages {
    stage('Terraform Init & Plan') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

            terraform init
            terraform plan -out=tfplan.binary
            terraform show -json tfplan.binary > tfplan.json
          '''
        }
      }
    }

    stage('Run terraform-compliance') {
      steps {
        script {
          def timestamp = new Date().format("yyyy-MM-dd-HH-mm")
          def desktopLogPath = "/home/khalid/desktop/compliance-log-${timestamp}.log"
          def workspaceLogPath = "compliance-log-${timestamp}.log"

          // Exécution avec redirection du log
          def complianceStatus = sh(
            script: """
              export PATH=\$PATH:/var/lib/jenkins/.local/bin
              terraform-compliance --no-color -p tfplan.json -f compliance/ > ${desktopLogPath}
              cp ${desktopLogPath} ${workspaceLogPath}
            """,
            returnStatus: true
          )

          // Archivage du log
          archiveArtifacts artifacts: workspaceLogPath, allowEmptyArchive: false
          // Affichage dans la console Jenkins
          def output = readFile(workspaceLogPath)
          echo output

          // Échec du build si terraform-compliance échoue
          if (complianceStatus != 0) {
            error("Terraform-compliance failed. See log for details.")
          }
        }
      }
    }
  }

  post {
    always {
      echo 'Pipeline finished. Compliance log saved on Desktop and archived.'
    }
    failure {
      echo 'Terraform compliance tests failed.'
    }
  }
}
