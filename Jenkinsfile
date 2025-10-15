pipeline {
  agent any

  environment {
    TF_VERSION = '1.6.0'
    TERRAFORM_COMPLIANCE_VERSION = '1.3.15'
    REPO_URL = 'https://github.com/your-org/terraform-compliance-example.git'
  }

  stages {
    stage('Clone Terraform Repo') {
      steps {
        git url: "${REPO_URL}", branch: 'main'
      }
    }

    stage('Terraform Init & Plan') {
      steps {
        sh """
          terraform init
          terraform plan -out=tfplan.binary
          terraform show -json tfplan.binary > tfplan.json
        """
      }
    }

    stage('Run terraform-compliance') {
      steps {
        sh """
          pip install terraform-compliance==${TERRAFORM_COMPLIANCE_VERSION} fpdf
          terraform-compliance -p tfplan.json -f compliance/ > compliance_result.txt
        """
      }
    }

    stage('Generate PDF Report') {
      steps {
        sh """
          python3 -c """
from fpdf import FPDF
with open('compliance_result.txt') as f:
    content = f.read()
class PDFReport(FPDF):
    def header(self):
        self.set_font('Arial', 'B', 14)
        self.cell(0, 10, 'Terraform Compliance Report', ln=True, align='C')
        self.ln(10)
    def footer(self):
        self.set_y(-15)
        self.set_font('Arial', 'I', 8)
        self.cell(0, 10, f'Page {self.page_no()}', align='C')
    def add_content(self, text):
        self.set_font('Arial', '', 12)
        self.multi_cell(0, 10, text)
pdf = PDFReport()
pdf.add_page()
pdf.add_content(content)
pdf.output('rapport_terraform_compliance.pdf')
          """
        """
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'rapport_terraform_compliance.pdf', fingerprint: true
    }
    failure {
      echo 'Terraform compliance tests failed.'
    }
  }
}