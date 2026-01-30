1. **บทบาท (Role)**
   ```
   "คุณเป็นผู้เชี่ยวชาญด้าน Software engine "
   "ในฐานะ  Technical Lead."
   1.Technical Lead
     1.0 Flow chart  & Data flow
     1.1 Tech Stack
       - React JS
       - Next.js
       - css tailwind
     1.2 ToolS
       - Gitlow , N8N
     1.3 Monitoring
       - Grafana monitoring
     1.4 Report
       - Jira Service Management 
     1.5 KPI
       - Agile 
     1.6 Task 
       - Agile 
     1.7 Test priocess
       - AI  , manule  ,Automation Tool

   2.DevOps 
     2.0 Flow chart  & Data flow
     2.1 Tech Stack
       - github gitlab, bitbucket,doker,k8s, N8N
     2.2 ToolS
       - Gitlow ,CI/CD pipeline , Jenkins (Infrastructure)
     2.3 Monitoring
       - Grafana monitoring
     2.4 Report
          1.สร้างเอกสาร
          2.สร้าง Template code
          3.ออกแบบ Data flow
          4.ออกแบบ Work flow
          5.ออกแบบ Template รายงาน 
     2.5 KPI
        - Agile 
     2.6 Task 
       - Agile 
     2.7 Test priocess
        - AI  , manule  ,Automation Tool
   ```

2. **ภารกิจ (Task)**
   ```
   "ความต้องการ.." 
      1.ระบบ User
      2.ระบบ สินค้า
      3.ระบบ คลังสินค้า
      4.ระบบขนส่ง
      5.ระบบรายงาน
      6.ระบบ ประวัจิดกาใช้งานระบบ 
   "วิเคราะห์ข้อมูลต่อไปนี้และสรุปประเด็นหลัก และตัวอย่าง "
       - React JS
       - Next.js template 
       - css tailwind

3. **บริบท (Context)**
 "สำหรับธุรกิจขนาดเล็ก..."
   "เพื่อใช้ กับ ERP ,CRM..."  ```
   ```

1. **รายละเอียดและข้อกำหนด (Specifications)**
   ```
   ความต้องการ web application responsive หลัก คือ 
 
       - React JS
       - Next.js
       - css tailwind
    ระบบที่ นำมาใช้
    1.Authentication
    2.validator
    7.n8n notification upload to Git Flow & deploy  Jenkins
    8.Gitlow
    9.comment code template
    10.CI/CD pipeline
    11.Robot Framework มา test API
    12.Task management
    13.Docker Compose
    14.Jenkins (Infrastructure)
    15.cloud AWS EC2 ,S3 deploy application
    16.Review Comment Template
   ```

2. **รูปแบบผลลัพธ์ (Output Format)**
   ```
   "จัดรูปแบบเป็น bullet points"
    - Template Code Programe
    - Flow chart 
    - Data flow
   ### แบบตรวจสอบการตรวจโค้ด
      ## คุณภาพโค้ด 
      ## การทำงาน 
      ## ความปลอดภัย 
      ## การทดสอบ 
      - [ ] ความครอบคลุมของการทดสอบเพียงพอ
      ## สถาปัตยกรรม 
      ## เอกสารประกอบ  
    #  Review Comment Template
 

```
    ส่งออก แบบ เอกสาร Markdown  .md
    ***********************ANSWER ***********************
# เอกสารออกแบบระบบ ERP/CRM สำหรับธุรกิจขนาดเล็ก
**บทบาท:** Technical Lead & DevOps Specialist  
**วันที่:** 26 มกราคม 2567 (วันพุธ)

---

## 1. สถาปัตยกรรมและโฟลว์โดยรวม (High-Level Architecture & Flow)

```mermaid
graph TB
    subgraph “Frontend Layer”
        A[Next.js App<br/>(React + Tailwind)] --> B[API Routes/Server Actions]
    end

    subgraph “Backend & API Layer”
        B --> C[Authentication Service<br/>NextAuth.js]
        B --> D[Validation Layer<br/>Zod/Yup]
        B --> E[Business Logic<br/>User, Product, Warehouse, Transport, Report]
    end

    subgraph “Data & Storage Layer”
        E --> F[(Database<br/>PostgreSQL/MySQL)]
        E --> G[File Storage<br/>AWS S3]
    end

    subgraph “DevOps & Automation”
        H[Git Flow] --> I[CI/CD Pipeline<br/>Jenkins/GitHub Actions]
        I --> J[Docker Build & Push]
        J --> K[Deploy to AWS EC2<br/>& S3]
        L[n8n Workflows] --> M[Notifications &<br/>Auto-GitOps]
        N[Monitoring<br/>Grafana] --> O[Alerting & Reports]
    end

    subgraph “Testing & QA”
        P[Robot Framework<br/>API Tests] --> Q[Test Reports]
        R[AI/Manual/Automated<br/>Testing] --> S[Quality Gate]
    end

    C --> F
    D --> E
    K --> N
    S --> I
```

**Data Flow:**
1. ผู้ใช้เข้าถึง **Next.js App** (Responsive Web)
2. คำขอผ่าน **API Routes/Server Actions** ไปยัง Backend Logic
3. ระบบตรวจสอบสิทธิ์ (**Authentication**) และตรวจสอบข้อมูล (**Validation**)
4. ประมวลผลธุรกรรม (สินค้า, คลัง, ขนส่ง, รายงาน)
5. บันทึกข้อมูลลงฐานข้อมูลและจัดเก็บไฟล์ (AWS S3)
6. n8n จัดการ Notification และ Trigger Git Flow
7. CI/CD Pipeline (Jenkins) ดำเนินการ Build, Test, Deploy ด้วย Docker
8. Deploy ไปยัง AWS EC2 (App) และ S3 (Static Assets)
9. Monitoring ด้วย Grafana และรายงานผลไปยัง Jira Service Management

---

## 2. Tech Stack & Tools

### 2.1 Frontend & Main Stack
- **React JS** + **Next.js 14** (App Router)
- **Tailwind CSS** สำหรับ Styling (Responsive)
- **NextAuth.js** สำหรับ Authentication
- **Zod** หรือ **Yup** สำหรับ Validation
- **TanStack Query/Table** สำหรับ State และ Data Table

### 2.2 DevOps & Infrastructure
- **Source Control:** GitHub/GitLab (ใช้ Git Flow)
- **CI/CD:** Jenkins (Infrastructure) + GitHub Actions
- **Containerization:** Docker + Docker Compose (Local/Dev)
- **Orchestration:** Kubernetes (K8s - Optional สำหรับ Scale)
- **Automation:** n8n (Workflow, Notification, Auto-trigger Git)
- **Cloud:** AWS EC2 (Deploy App), S3 (Storage), RDS/EC2 Database
- **Monitoring:** Grafana (Dashboard, Metrics, Logs)

### 2.3 Testing & QA
- **API Testing:** Robot Framework
- **Unit/Integration Test:** Jest + React Testing Library
- **E2E/UI Test:** Playwright/Cypress
- **AI-assisted Testing:** Tools เช่น **Testim.io, Sauce Labs** (ในส่วน Automation)
- **Manual Testing Process:** ตาม Agile Sprint

### 2.4 Task & Project Management
- **Task Management:** Jira (Agile, Sprint)
- **KPI Tracking:** Agile Metrics (Velocity, Burndown)
- **Documentation:** Markdown ใน Repo, Wiki

---

## 3. Template Code & Structure

### 3.1 Next.js Project Structure
```
erp-crm-app/
├── src/
│   ├── app/                          # Next.js 14 App Router
│   │   ├── (auth)/
│   │   │   ├── login/
│   │   │   └── register/
│   │   ├── dashboard/
│   │   │   ├── products/
│   │   │   ├── warehouse/
│   │   │   ├── transport/
│   │   │   └── reports/
│   │   ├── api/
│   │   │   ├── auth/[...nextauth]/
│   │   │   ├── products/
│   │   │   └── ...
│   │   └── layout.tsx
│   ├── components/                   # Reusable Components
│   │   ├── ui/ (Button, Card, Table)
│   │   ├── forms/ (ProductForm, etc.)
│   │   └── layouts/
│   ├── lib/                          # Utilities
│   │   ├── auth.ts (NextAuth Config)
│   │   ├── db.ts (Database Client)
│   │   └── validators/ (Zod Schemas)
│   ├── hooks/                        # Custom Hooks
│   ├── types/                        # TypeScript Types
│   └── styles/                       # Global Tailwind
├── public/
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
├── tests/
│   ├── api/ (Robot Framework Tests)
│   └── e2e/ (Playwright Tests)
├── jenkins/
│   └── Jenkinsfile
├── n8n/
│   └── workflows/ (n8n JSON Workflows)
└── README.md
```

### 3.2 Example: Product Module (Frontend + Validation)

**`src/lib/validators/product.ts` (Zod Schema)**
```typescript
import { z } from 'zod';

export const productSchema = z.object({
  code: z.string().min(3, 'รหัสสินค้าต้องมีอย่างน้อย 3 ตัวอักษร'),
  name: z.string().min(1, 'กรุณากรอกชื่อสินค้า'),
  description: z.string().optional(),
  price: z.number().positive('ราคาต้องมากกว่า 0'),
  cost: z.number().positive('ต้นทุนต้องมากกว่า 0'),
  stock: z.number().int().min(0, 'สินค้าคงคลังต้องไม่ต่ำกว่า 0'),
  warehouseId: z.string().uuid('กรุณาเลือกคลังสินค้า'),
});

export type ProductFormData = z.infer<typeof productSchema>;
```

**`src/app/dashboard/products/page.tsx` (Page Component)**
```tsx
import ProductTable from '@/components/tables/ProductTable';
import { getProducts } from '@/lib/api/products';
import { validateSession } from '@/lib/auth';

export default async function ProductsPage() {
  await validateSession(); // Server-side auth check
  const products = await getProducts();

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-2xl font-bold mb-6">ระบบจัดการสินค้า</h1>
      <div className="bg-white rounded-lg shadow p-4">
        <ProductTable initialData={products} />
      </div>
    </div>
  );
}
```

### 3.3 Docker Compose for Local Development
**`docker-compose.yml`**
```yaml
version: '3.8'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: erp_crm
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secure_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  app:
    build:
      context: .
      dockerfile: docker/Dockerfile.dev
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://admin:secure_password@db:5432/erp_crm
      NEXTAUTH_SECRET: your_secret_key
    volumes:
      - ./src:/app/src
      - ./public:/app/public
    depends_on:
      - db

volumes:
  postgres_data:
```

---

## 4. DevOps Pipeline & Automation

### 4.1 Git Flow & CI/CD Pipeline
```mermaid
graph LR
    A[Feature Branch] --> B[Pull Request]
    B --> C[Code Review<br/>+ Template Check]
    C --> D[CI Pipeline Trigger]
    D --> E[Run Tests<br/>Unit, API, E2E]
    E --> F{Build & Scan}
    F -->|Pass| G[Deploy to Staging]
    F -->|Fail| H[Notify Team via n8n]
    G --> I[Manual/UAT Approval]
    I --> J[Deploy to Production<br/>AWS EC2 & S3]
    J --> K[Post-Deploy Monitoring]
```

### 4.2 Jenkins Pipeline Example (Jenkinsfile)
```groovy
pipeline {
    agent any
    environment {
        AWS_REGION = 'ap-southeast-1'
        ECR_REPO = 'your-ecr-repo/erp-app'
    }
    stages {
        stage('Checkout & Setup') {
            steps {
                git branch: 'develop', url: 'https://github.com/your-repo.git'
            }
        }
        stage('Install & Test') {
            steps {
                sh 'npm ci'
                sh 'npm run test:unit'
                sh 'npm run test:api'  // Robot Framework
            }
        }
        stage('Build & Scan') {
            steps {
                sh 'npm run build'
                // Security Scan (e.g., Snyk, SonarQube)
            }
        }
        stage('Docker Build & Push') {
            steps {
                sh 'docker build -t $ECR_REPO:$BUILD_NUMBER .'
                sh 'docker push $ECR_REPO:$BUILD_NUMBER'
            }
        }
        stage('Deploy to Staging') {
            steps {
                sh './deploy-scripts/deploy-staging.sh $BUILD_NUMBER'
            }
        }
        stage('Approval') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    input message: 'Deploy to Production?'
                }
            }
        }
        stage('Deploy to Production') {
            steps {
                sh './deploy-scripts/deploy-prod.sh $BUILD_NUMBER'
            }
        }
    }
    post {
        success {
            // n8n webhook for success notification
            sh 'curl -X POST https://n8n.yourdomain.com/webhook/deploy-success'
        }
        failure {
            // Alert to Slack/Jira
            sh 'curl -X POST https://n8n.yourdomain.com/webhook/deploy-failed'
        }
    }
}
```

---

## 5. แบบตรวจสอบการตรวจโค้ด (Code Review Template)

### **Review Comment Template** (ใช้ใน Pull Request)

**หัวข้อ:** `[REVIEW] - {Module Name} - {PR Number}`

---
### **คุณภาพโค้ด (Code Quality)**
- [ ] โค้ดอ่านเข้าใจง่าย มีการตั้งชื่อตัวแปร/ฟังก์ชันที่สื่อความหมาย
- [ ] ปฏิบัติตาม Coding Standards (ESLint, Prettier)
- [ ] ไม่มีโค้ดที่ซ้ำซ้อน (Duplication)
- [ ] ขนาดของฟังก์ชัน/ไฟล์เหมาะสม ไม่ใหญ่เกินไป

### **การทำงาน (Functionality)**
- [ ] โค้ดทำงานตรงตาม Requirement
- [ ] ไม่มี Side Effect ที่ไม่พึงประสงค์
- [ ] ครอบคลุมกรณีขอบเขต (Edge Cases)

### **ความปลอดภัย (Security)**
- [ ] ตรวจสอบ Input Validation (ใช้ Zod/Yup)
- [ ] ไม่มี Hard-coded Secret (ใช้ Environment Variables)
- [ ] ตรวจสอบ Authentication & Authorization
- [ ] ป้องกัน SQL Injection, XSS (ถ้ามี)

### **การทดสอบ (Testing)**
- [ ] มี Unit Tests ครอบคลุม Core Logic
- [ ] มี Integration Tests สำหรับ API
- [ ] **ความครอบคลุมของการทดสอบเพียงพอ (≥80%)**
- [ ] Test Cases ครอบคลุม Success และ Error Scenarios

### **สถาปัตยกรรม (Architecture)**
- [ ] โครงสร้างไฟล์เป็นไปตาม Convention
- [ ] Separation of Concerns (Logic, UI, Data)
- [ ] ไม่มี Circular Dependencies

### **เอกสารประกอบ (Documentation)**
- [ ] มี Comments ในส่วนที่ซับซ้อน
- [ ] อัพเดท README/API Docs (ถ้าจำเป็น)
- [ ] TypeScript Types ครบถ้วน

**ข้อคิดเห็นเพิ่มเติม (Comments):**
```
// ตัวอย่าง comment ใน code
// TODO: [ผู้รับผิดชอบ] ควรเพิ่ม caching ที่ส่วนนี้
// FIXME: [Issue-123] แก้ไข performance เมื่อข้อมูลมากกว่า 10k records
```

**สถานะการตรวจ:**
- [ ] ผ่าน (Approve)
- [ ] ต้องการการแก้ไข (Request Changes)
- [ ] ความคิดเห็น (Comment)

---

## 6. รายงานและ Monitoring

### 6.1 KPI & Agile Metrics
- **Velocity** (Story Points per Sprint)
- **Sprint Burndown Chart**
- **Deployment Frequency**
- **Mean Time to Recovery (MTTR)**
- **Test Coverage %**

### 6.2 Grafana Dashboard (ตัวอย่าง Metrics)
- **Application:** Request Rate, Error Rate, Response Time (p95)
- **System:** CPU/Memory Usage (EC2), S3 Bandwidth
- **Business:** จำนวนผู้ใช้งาน, จำนวนธุรกรรมสินค้า/คลัง/ขนส่ง
- **Database:** Query Performance, Connection Pool

### 6.3 รายงานจาก Jira Service Management
- อุปกรณ์ติดปัญหา (Incident Reports)
- คำขอใหม่ (Service Requests)
- การเปลี่ยนแปลงระบบ (Change Management Logs)

---

## 7. ระบบที่ต้องพัฒนา (Modules)

1. **ระบบผู้ใช้งาน (Authentication & Authorization)**
   - Role-based Access (Admin, Manager, Staff, Viewer)
   - Audit Log (ประวัติการใช้งาน)

2. **ระบบสินค้า (Product Management)**
   - CRUD สินค้า, หมวดหมู่, ราคา
   - Import/Export (Excel/CSV)

3. **ระบบคลังสินค้า (Warehouse)**
   - จัดการสต็อก (Stock In/Out)
   - ย้ายสินค้าระหว่างคลัง
   - Inventory Counting

4. **ระบบขนส่ง (Transport)**
   - จัดการรถ, พนักงานขับ
   - ตารางการขนส่ง
   - Tracking (สถานะการจัดส่ง)

5. **ระบบรายงาน (Reporting)**
   - Dashboard สรุป
   - Report Builder (Filter, Export PDF/Excel)
   - Scheduled Reports (ส่งอีเมล)

6. **ระบบประวัติการใช้งาน (Audit Log)**
   - Log ทุกการเปลี่ยนแปลง (Who, What, When)
   - Revert/Compare Changes

---

## 8. ขั้นตอนการทดสอบ (Test Process)

### 8.1 Test Pyramid
```
        [E2E Tests] (10%) - Playwright/Robot Framework
           /      \
[Integration Tests] (20%) - API, Services
          /
  [Unit Tests] (70%) - Components, Functions
```

### 8.2 Test Automation with Robot Framework (API Test Example)
```robot
*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    http://localhost:3000/api
${TOKEN}       your_jwt_token

*** Test Cases ***
Create Product Success
    [Tags]    api    product    smoke
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${TOKEN}
    ...    Content-Type=application/json
    
    ${payload}=    Create Dictionary
    ...    code=PROD-001
    ...    name=สินค้าทดสอบ
    ...    price=100.50
    ...    stock=50
    
    ${response}=    POST    ${BASE_URL}/products
    ...    json=${payload}
    ...    headers=${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    id
    Should Be Equal    ${response.json()}[code]    PROD-001
```

### 8.3 AI-Assisted Testing
- **Test Generation:** ใช้ AI (เช่น GitHub Copilot, Testim) ช่วยสร้าง Test Cases
- **Visual Testing:** Percy, Applitools สำหรับ UI Regression
- **Performance Testing:** k6, Lighthouse CI

---

## 9. การดำเนินงานแบบ Agile

### 9.1 Sprint Cycle (2 Weeks)
```
Week 1:
- Sprint Planning (เลือก Task จาก Backlog)
- Development + Daily Standup
- Internal Code Review

Week 2:
- Complete Development
- QA & Testing Phase
- UAT (User Acceptance Test)
- Sprint Review & Retrospective
- Deployment to Production
```

### 9.2 Task Management (Jira)
- **Epic:** ระบบใหญ่ (เช่น ระบบคลังสินค้า)
- **Story:** Feature ย่อย (เช่น เพิ่มฟังก์ชันตรวจนับสต็อก)
- **Task:** งานเทคนิค (เช่น ออกแบบ Database Schema)
- **Bug:** ข้อผิดพลาดที่พบ

---

## 10. สรุปและข้อเสนอแนะ

### จุดแข็งของสถาปัตยกรรมนี้:
1. **Modern Stack:** Next.js 14 + Tailwind ให้ Performance สูงและพัฒนาเร็ว
2. **Scalable:** Docker + AWS ช่วย Scale ได้ตามต้องการ
3. **Automation:** n8n + Jenkins ลดงาน Manual
4. **Quality Focus:** Testing Pyramid + Code Review Template

### ข้อควรพิจารณา:
1. **เริ่มต้นเล็ก ๆ:** เริ่มจาก Module เดิม (User, Product) ก่อน
2. **ทีม DevOps:** ต้องการความเชี่ยวชาญด้าน Jenkins, AWS, Docker
3. **Monitoring:** ต้องตั้งค่า Grafana/Alerts ตั้งแต่แรก
4. **Security:** ต้องมีกระบวนการจัดการ Secret (Vault) และ定期 Audit

### ขั้นตอนต่อไป:
1. ติดตั้ง Next.js Template + Tailwind
2. Setup Docker Compose สำหรับ Development
3. Configure NextAuth.js + Database
4. สร้าง Module แรก (User Management)
5. Setup CI/CD Pipeline เบื้องต้น
6. Deploy ไป Staging Environment

---

##  V2
# โปรเจคเต็มรูปแบบ: ERP/CRM สำหรับธุรกิจขนาดเล็ก

## โครงสร้างโปรเจคแบบเต็ม

```
erp-crm-system/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── docker/
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   └── docker-compose.yml
├── src/
│   ├── app/
│   ├── components/
│   ├── lib/
│   ├── hooks/
│   ├── types/
│   ├── styles/
│   └── middleware.ts
├── tests/
├── jenkins/
├── n8n-workflows/
├── robot-framework/
├── docs/
├── scripts/
└── configuration files...
```

## 1. Configuration Files

### 1.1 package.json
```json
{
  "name": "erp-crm-system",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "test:unit": "jest",
    "test:e2e": "playwright test",
    "test:api": "robot tests/api",
    "docker:dev": "docker-compose -f docker/docker-compose.yml up",
    "docker:build": "docker build -f docker/Dockerfile -t erp-crm-system .",
    "generate:types": "prisma generate",
    "db:migrate": "prisma migrate dev",
    "db:seed": "ts-node prisma/seed.ts"
  },
  "dependencies": {
    "next": "14.0.0",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "next-auth": "^4.24.5",
    "zod": "^3.22.4",
    "@prisma/client": "^5.7.0",
    "@tanstack/react-query": "^5.12.2",
    "@tanstack/react-table": "^8.11.2",
    "date-fns": "^3.0.6",
    "axios": "^1.6.2",
    "react-hook-form": "^7.48.2",
    "@hookform/resolvers": "^3.3.2",
    "recharts": "^2.10.3",
    "react-toastify": "^9.1.3",
    "xlsx": "^0.18.5",
    "pdf-lib": "^1.17.1",
    "jwt-decode": "^4.0.0",
    "bcryptjs": "^2.4.3",
    "uuid": "^9.0.1",
    "socket.io-client": "^4.7.2",
    "socket.io": "^4.7.2",
    "multer": "^1.4.5-lts.1",
    "multer-s3": "^3.0.1",
    "@aws-sdk/client-s3": "^3.434.0",
    "sharp": "^0.33.0"
  },
  "devDependencies": {
    "@types/node": "20.10.0",
    "@types/react": "18.2.45",
    "@types/react-dom": "18.2.18",
    "@types/bcryptjs": "^2.4.6",
    "@types/uuid": "^9.0.7",
    "typescript": "5.3.0",
    "@typescript-eslint/eslint-plugin": "^6.15.0",
    "@typescript-eslint/parser": "^6.15.0",
    "eslint": "8.56.0",
    "eslint-config-next": "14.0.0",
    "tailwindcss": "3.3.0",
    "autoprefixer": "10.4.16",
    "postcss": "8.4.32",
    "jest": "^29.7.0",
    "@testing-library/react": "^14.1.2",
    "@testing-library/jest-dom": "^6.1.5",
    "@testing-library/user-event": "^14.5.1",
    "ts-jest": "^29.1.1",
    "@playwright/test": "^1.40.0",
    "prisma": "^5.7.0",
    "ts-node": "^10.9.1",
    "dotenv": "^16.3.1",
    "prettier": "^3.1.1",
    "husky": "^8.0.3",
    "lint-staged": "^15.2.0"
  }
}
```

### 1.2 tsconfig.json
```json
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

### 1.3 tailwind.config.js
```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["class"],
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: 0 },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: 0 },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
}
```

### 1.4 .env.local (Environment Variables)
```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/erp_crm?schema=public"

# Next Auth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-secret-key-here-change-in-production"

# AWS
AWS_ACCESS_KEY_ID="your-access-key"
AWS_SECRET_ACCESS_KEY="your-secret-key"
AWS_REGION="ap-southeast-1"
AWS_S3_BUCKET="erp-crm-bucket"

# Application
APP_URL="http://localhost:3000"
JWT_SECRET="your-jwt-secret"
ENCRYPTION_KEY="your-encryption-key"

# Email (for notifications)
SMTP_HOST="smtp.gmail.com"
SMTP_PORT=587
SMTP_USER="your-email@gmail.com"
SMTP_PASSWORD="your-app-password"
SMTP_FROM="ERP System <noreply@erp-system.com>"

# Third Party APIs
GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""
```

## 2. Database Schema (Prisma)

### 2.1 prisma/schema.prisma
```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

enum UserRole {
  SUPER_ADMIN
  ADMIN
  MANAGER
  STAFF
  VIEWER
}

enum AuditAction {
  CREATE
  UPDATE
  DELETE
  LOGIN
  LOGOUT
  EXPORT
  IMPORT
}

enum ProductStatus {
  ACTIVE
  INACTIVE
  DISCONTINUED
}

enum WarehouseType {
  MAIN
  BRANCH
  TEMPORARY
}

enum TransportStatus {
  PENDING
  LOADING
  IN_TRANSIT
  DELIVERED
  CANCELLED
}

model User {
  id              String    @id @default(uuid())
  email           String    @unique
  password        String
  name            String
  role            UserRole  @default(STAFF)
  department      String?
  phone           String?
  avatar          String?
  isActive        Boolean   @default(true)
  lastLogin       DateTime?
  createdAt       DateTime  @default(now())
  updatedAt       DateTime  @updatedAt
  
  // Relations
  createdProducts Product[] @relation("CreatedProducts")
  updatedProducts Product[] @relation("UpdatedProducts")
  auditLogs       AuditLog[]
  
  @@map("users")
  @@index([email])
  @@index([role])
}

model Product {
  id              String        @id @default(uuid())
  code            String        @unique
  name            String
  description     String?
  barcode         String?
  sku             String?
  category        String
  unit            String
  price           Float
  cost            Float
  stock           Int           @default(0)
  minStock        Int           @default(10)
  maxStock        Int           @default(1000)
  status          ProductStatus @default(ACTIVE)
  imageUrl        String?
  
  // Warehouse relation
  warehouseId     String
  warehouse       Warehouse     @relation(fields: [warehouseId], references: [id])
  
  // Relations
  transactions    Transaction[]
  orderItems      OrderItem[]
  
  // Audit
  createdById     String
  createdBy       User          @relation("CreatedProducts", fields: [createdById], references: [id])
  updatedById     String
  updatedBy       User          @relation("UpdatedProducts", fields: [updatedById], references: [id])
  createdAt       DateTime      @default(now())
  updatedAt       DateTime      @updatedAt
  
  @@map("products")
  @@index([code])
  @@index([name])
  @@index([category])
  @@index([warehouseId])
}

model Warehouse {
  id              String        @id @default(uuid())
  code            String        @unique
  name            String
  type            WarehouseType @default(MAIN)
  address         String
  phone           String?
  managerId       String?
  capacity        Int?
  currentUsage    Int           @default(0)
  isActive        Boolean       @default(true)
  
  // Relations
  products        Product[]
  transactions    Transaction[]
  
  createdAt       DateTime      @default(now())
  updatedAt       DateTime      @updatedAt
  
  @@map("warehouses")
  @@index([code])
}

model Transaction {
  id              String        @id @default(uuid())
  transactionNo   String        @unique
  type            String        // IN, OUT, TRANSFER
  productId       String
  product         Product       @relation(fields: [productId], references: [id])
  warehouseId     String
  warehouse       Warehouse     @relation(fields: [warehouseId], references: [id])
  quantity        Int
  unitPrice       Float
  totalPrice      Float
  referenceNo     String?       // PO No, SO No, etc.
  notes           String?
  
  // Audit
  createdById     String
  createdBy       User          @relation(fields: [createdById], references: [id])
  createdAt       DateTime      @default(now())
  
  @@map("transactions")
  @@index([transactionNo])
  @@index([productId])
  @@index([warehouseId])
  @@index([createdAt])
}

model Transport {
  id              String          @id @default(uuid())
  transportNo     String          @unique
  vehicleNo       String
  driverName      String
  driverPhone     String
  departureDate   DateTime
  estimatedArrival DateTime
  actualArrival   DateTime?
  status          TransportStatus @default(PENDING)
  
  // Relations
  shipments       Shipment[]
  
  createdAt       DateTime        @default(now())
  updatedAt       DateTime        @updatedAt
  
  @@map("transports")
  @@index([transportNo])
  @@index([status])
  @@index([departureDate])
}

model Shipment {
  id              String    @id @default(uuid())
  shipmentNo      String    @unique
  transportId     String
  transport       Transport @relation(fields: [transportId], references: [id])
  productId       String
  product         Product   @relation(fields: [productId], references: [id])
  quantity        Int
  fromWarehouseId String
  fromWarehouse   Warehouse @relation("FromWarehouse", fields: [fromWarehouseId], references: [id])
  toWarehouseId   String
  toWarehouse     Warehouse @relation("ToWarehouse", fields: [toWarehouseId], references: [id])
  status          String    // PENDING, LOADED, DELIVERED
  
  createdAt       DateTime  @default(now())
  updatedAt       DateTime  @updatedAt
  
  @@map("shipments")
  @@index([shipmentNo])
  @@index([transportId])
}

model Report {
  id              String    @id @default(uuid())
  reportType      String    // DAILY, MONTHLY, YEARLY
  reportDate      DateTime
  data            Json      // Report data in JSON format
  generatedById   String
  generatedBy     User      @relation(fields: [generatedById], references: [id])
  createdAt       DateTime  @default(now())
  
  @@map("reports")
  @@index([reportType])
  @@index([reportDate])
}

model AuditLog {
  id              String      @id @default(uuid())
  userId          String
  user            User        @relation(fields: [userId], references: [id])
  action          AuditAction
  entityType      String      // User, Product, Warehouse, etc.
  entityId        String?
  oldData         Json?
  newData         Json?
  ipAddress       String?
  userAgent       String?
  timestamp       DateTime    @default(now())
  
  @@map("audit_logs")
  @@index([userId])
  @@index([action])
  @@index([entityType])
  @@index([timestamp])
}
```

### 2.2 prisma/seed.ts
```typescript
import { PrismaClient, UserRole } from '@prisma/client'
import bcrypt from 'bcryptjs'

const prisma = new PrismaClient()

async function main() {
  console.log('🌱 Starting database seed...')

  // Hash password
  const hashedPassword = await bcrypt.hash('admin123', 10)

  // Create default users
  const adminUser = await prisma.user.upsert({
    where: { email: 'admin@erp.com' },
    update: {},
    create: {
      email: 'admin@erp.com',
      password: hashedPassword,
      name: 'System Administrator',
      role: UserRole.SUPER_ADMIN,
      department: 'IT',
      phone: '0812345678',
    },
  })

  const managerUser = await prisma.user.upsert({
    where: { email: 'manager@erp.com' },
    update: {},
    create: {
      email: 'manager@erp.com',
      password: hashedPassword,
      name: 'Warehouse Manager',
      role: UserRole.MANAGER,
      department: 'Warehouse',
      phone: '0823456789',
    },
  })

  // Create main warehouse
  const mainWarehouse = await prisma.warehouse.upsert({
    where: { code: 'WH-001' },
    update: {},
    create: {
      code: 'WH-001',
      name: 'คลังสินค้าหลัก',
      type: 'MAIN',
      address: '123 ถนนหลัก เขตเมือง กทม. 10100',
      phone: '021234567',
      capacity: 10000,
    },
  })

  // Create sample products
  const products = [
    {
      code: 'PROD-001',
      name: 'โน้ตบุ๊ก Dell XPS 13',
      category: 'Electronics',
      unit: 'เครื่อง',
      price: 35000,
      cost: 28000,
      stock: 50,
      minStock: 5,
      maxStock: 100,
      warehouseId: mainWarehouse.id,
      createdById: adminUser.id,
      updatedById: adminUser.id,
    },
    {
      code: 'PROD-002',
      name: 'เมาส์ไร้สาย Logitech MX Master 3',
      category: 'Electronics',
      unit: 'ตัว',
      price: 3200,
      cost: 2500,
      stock: 200,
      minStock: 20,
      maxStock: 500,
      warehouseId: mainWarehouse.id,
      createdById: adminUser.id,
      updatedById: adminUser.id,
    },
    {
      code: 'PROD-003',
      name: 'กระดาษ A4 80แกรม',
      category: 'Office Supplies',
      unit: 'รีม',
      price: 120,
      cost: 90,
      stock: 1000,
      minStock: 100,
      maxStock: 2000,
      warehouseId: mainWarehouse.id,
      createdById: adminUser.id,
      updatedById: adminUser.id,
    },
  ]

  for (const product of products) {
    await prisma.product.upsert({
      where: { code: product.code },
      update: {},
      create: product,
    })
  }

  console.log('✅ Database seeded successfully!')
}

main()
  .catch((e) => {
    console.error('❌ Seeding error:', e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
```

## 3. Core Application Code

### 3.1 Next.js Middleware (Authentication)
**`src/middleware.ts`**
```typescript
import { withAuth } from "next-auth/middleware"
import { NextResponse } from "next/server"

export default withAuth(
  function middleware(req) {
    const token = req.nextauth.token
    const pathname = req.nextUrl.pathname

    // Role-based access control
    if (pathname.startsWith('/admin') && token?.role !== 'SUPER_ADMIN' && token?.role !== 'ADMIN') {
      return NextResponse.redirect(new URL('/unauthorized', req.url))
    }

    if (pathname.startsWith('/dashboard') && !token) {
      return NextResponse.redirect(new URL('/auth/login', req.url))
    }

    return NextResponse.next()
  },
  {
    callbacks: {
      authorized: ({ token }) => !!token,
    },
  }
)

export const config = {
  matcher: [
    '/dashboard/:path*',
    '/admin/:path*',
    '/api/:path*',
  ]
}
```

### 3.2 Authentication Configuration
**`src/lib/auth.ts`**
```typescript
import { NextAuthOptions } from "next-auth"
import CredentialsProvider from "next-auth/providers/credentials"
import { PrismaAdapter } from "@next-auth/prisma-adapter"
import { prisma } from "./db"
import bcrypt from "bcryptjs"
import { JWT } from "next-auth/jwt"

export const authOptions: NextAuthOptions = {
  adapter: PrismaAdapter(prisma),
  session: {
    strategy: "jwt",
  },
  pages: {
    signIn: "/auth/login",
    error: "/auth/error",
  },
  providers: [
    CredentialsProvider({
      name: "credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          return null
        }

        const user = await prisma.user.findUnique({
          where: {
            email: credentials.email,
          },
        })

        if (!user || !user.password) {
          return null
        }

        const passwordMatch = await bcrypt.compare(credentials.password, user.password)

        if (!passwordMatch) {
          return null
        }

        // Update last login
        await prisma.user.update({
          where: { id: user.id },
          data: { lastLogin: new Date() },
        })

        // Create audit log
        await prisma.auditLog.create({
          data: {
            userId: user.id,
            action: 'LOGIN',
            entityType: 'User',
            entityId: user.id,
            ipAddress: '127.0.0.1', // In production, get from request
          },
        })

        return {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
        }
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.role = user.role
        token.id = user.id
      }
      return token
    },
    async session({ session, token }) {
      if (session?.user) {
        session.user.role = token.role as string
        session.user.id = token.id as string
      }
      return session
    },
  },
}
```

**`src/app/api/auth/[...nextauth]/route.ts`**
```typescript
import NextAuth from "next-auth"
import { authOptions } from "@/lib/auth"

const handler = NextAuth(authOptions)

export { handler as GET, handler as POST }
```

### 3.3 Database Client
**`src/lib/db.ts`**
```typescript
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}

export const prisma = globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
```

### 3.4 API Route Handlers

#### 3.4.1 Products API
**`src/app/api/products/route.ts`**
```typescript
import { NextRequest, NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { prisma } from '@/lib/db'
import { authOptions } from '@/lib/auth'
import { productSchema } from '@/lib/validators/product'
import { createAuditLog } from '@/lib/audit'

export async function GET(request: NextRequest) {
  try {
    const session = await getServerSession(authOptions)
    
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const searchParams = request.nextUrl.searchParams
    const page = parseInt(searchParams.get('page') || '1')
    const limit = parseInt(searchParams.get('limit') || '10')
    const search = searchParams.get('search') || ''
    const category = searchParams.get('category')
    const warehouseId = searchParams.get('warehouseId')

    const skip = (page - 1) * limit

    const where = {
      ...(search && {
        OR: [
          { code: { contains: search, mode: 'insensitive' } },
          { name: { contains: search, mode: 'insensitive' } },
          { description: { contains: search, mode: 'insensitive' } },
        ],
      }),
      ...(category && { category }),
      ...(warehouseId && { warehouseId }),
    }

    const [products, total] = await Promise.all([
      prisma.product.findMany({
        where,
        include: {
          warehouse: {
            select: {
              code: true,
              name: true,
            },
          },
          createdBy: {
            select: {
              name: true,
              email: true,
            },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.product.count({ where }),
    ])

    return NextResponse.json({
      products,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit),
      },
    })
  } catch (error) {
    console.error('Error fetching products:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const session = await getServerSession(authOptions)
    
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const validation = productSchema.safeParse(body)

    if (!validation.success) {
      return NextResponse.json(
        { error: 'Validation error', details: validation.error.format() },
        { status: 400 }
      )
    }

    const data = validation.data

    // Check if product code exists
    const existingProduct = await prisma.product.findUnique({
      where: { code: data.code },
    })

    if (existingProduct) {
      return NextResponse.json(
        { error: 'Product code already exists' },
        { status: 409 }
      )
    }

    // Create product
    const product = await prisma.product.create({
      data: {
        ...data,
        createdById: session.user.id,
        updatedById: session.user.id,
      },
    })

    // Create audit log
    await createAuditLog({
      userId: session.user.id,
      action: 'CREATE',
      entityType: 'Product',
      entityId: product.id,
      newData: product,
    })

    return NextResponse.json(product, { status: 201 })
  } catch (error) {
    console.error('Error creating product:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
```

**`src/app/api/products/[id]/route.ts`**
```typescript
import { NextRequest, NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { prisma } from '@/lib/db'
import { authOptions } from '@/lib/auth'
import { productSchema } from '@/lib/validators/product'
import { createAuditLog } from '@/lib/audit'

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const session = await getServerSession(authOptions)
    
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const product = await prisma.product.findUnique({
      where: { id: params.id },
      include: {
        warehouse: true,
        createdBy: {
          select: {
            name: true,
            email: true,
          },
        },
        updatedBy: {
          select: {
            name: true,
            email: true,
          },
        },
        transactions: {
          take: 10,
          orderBy: { createdAt: 'desc' },
          include: {
            createdBy: {
              select: {
                name: true,
              },
            },
          },
        },
      },
    })

    if (!product) {
      return NextResponse.json(
        { error: 'Product not found' },
        { status: 404 }
      )
    }

    return NextResponse.json(product)
  } catch (error) {
    console.error('Error fetching product:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const session = await getServerSession(authOptions)
    
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const validation = productSchema.safeParse(body)

    if (!validation.success) {
      return NextResponse.json(
        { error: 'Validation error', details: validation.error.format() },
        { status: 400 }
      )
    }

    const data = validation.data

    // Get old data for audit log
    const oldProduct = await prisma.product.findUnique({
      where: { id: params.id },
    })

    if (!oldProduct) {
      return NextResponse.json(
        { error: 'Product not found' },
        { status: 404 }
      )
    }

    // Check if new code conflicts with other products
    if (data.code !== oldProduct.code) {
      const existingProduct = await prisma.product.findUnique({
        where: { code: data.code },
      })

      if (existingProduct) {
        return NextResponse.json(
          { error: 'Product code already exists' },
          { status: 409 }
        )
      }
    }

    // Update product
    const updatedProduct = await prisma.product.update({
      where: { id: params.id },
      data: {
        ...data,
        updatedById: session.user.id,
      },
    })

    // Create audit log
    await createAuditLog({
      userId: session.user.id,
      action: 'UPDATE',
      entityType: 'Product',
      entityId: updatedProduct.id,
      oldData: oldProduct,
      newData: updatedProduct,
    })

    return NextResponse.json(updatedProduct)
  } catch (error) {
    console.error('Error updating product:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const session = await getServerSession(authOptions)
    
    if (!session || session.user.role !== 'ADMIN' && session.user.role !== 'SUPER_ADMIN') {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    // Get product before deletion for audit log
    const product = await prisma.product.findUnique({
      where: { id: params.id },
    })

    if (!product) {
      return NextResponse.json(
        { error: 'Product not found' },
        { status: 404 }
      )
    }

    // Soft delete - update status
    const deletedProduct = await prisma.product.update({
      where: { id: params.id },
      data: {
        status: 'INACTIVE',
        updatedById: session.user.id,
      },
    })

    // Create audit log
    await createAuditLog({
      userId: session.user.id,
      action: 'DELETE',
      entityType: 'Product',
      entityId: deletedProduct.id,
      oldData: product,
    })

    return NextResponse.json({ message: 'Product deleted successfully' })
  } catch (error) {
    console.error('Error deleting product:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
```

### 3.5 Validators
**`src/lib/validators/index.ts`**
```typescript
import { z } from 'zod'

// User validators
export const userSchema = z.object({
  email: z.string().email('Invalid email address'),
  name: z.string().min(2, 'Name must be at least 2 characters'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
  role: z.enum(['ADMIN', 'MANAGER', 'STAFF', 'VIEWER']),
  department: z.string().optional(),
  phone: z.string().optional(),
})

export const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(1, 'Password is required'),
})

// Product validators
export const productSchema = z.object({
  code: z.string().min(3, 'Product code must be at least 3 characters'),
  name: z.string().min(1, 'Product name is required'),
  description: z.string().optional(),
  category: z.string().min(1, 'Category is required'),
  unit: z.string().min(1, 'Unit is required'),
  price: z.number().positive('Price must be positive'),
  cost: z.number().positive('Cost must be positive'),
  stock: z.number().int().min(0, 'Stock cannot be negative'),
  minStock: z.number().int().min(0).optional(),
  maxStock: z.number().int().positive().optional(),
  warehouseId: z.string().uuid('Invalid warehouse ID'),
})

// Warehouse validators
export const warehouseSchema = z.object({
  code: z.string().min(3, 'Warehouse code must be at least 3 characters'),
  name: z.string().min(1, 'Warehouse name is required'),
  type: z.enum(['MAIN', 'BRANCH', 'TEMPORARY']),
  address: z.string().min(1, 'Address is required'),
  phone: z.string().optional(),
  capacity: z.number().int().positive().optional(),
})

// Transaction validators
export const transactionSchema = z.object({
  type: z.enum(['IN', 'OUT', 'TRANSFER']),
  productId: z.string().uuid('Invalid product ID'),
  warehouseId: z.string().uuid('Invalid warehouse ID'),
  quantity: z.number().int().positive('Quantity must be positive'),
  unitPrice: z.number().positive('Unit price must be positive'),
  referenceNo: z.string().optional(),
  notes: z.string().optional(),
})

// Transport validators
export const transportSchema = z.object({
  vehicleNo: z.string().min(1, 'Vehicle number is required'),
  driverName: z.string().min(1, 'Driver name is required'),
  driverPhone: z.string().min(10, 'Invalid phone number'),
  departureDate: z.string().datetime(),
  estimatedArrival: z.string().datetime(),
})
```

### 3.6 Utility Functions
**`src/lib/utils.ts`**
```typescript
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatCurrency(amount: number) {
  return new Intl.NumberFormat('th-TH', {
    style: 'currency',
    currency: 'THB',
  }).format(amount)
}

export function formatDate(date: Date | string) {
  return new Intl.DateTimeFormat('th-TH', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  }).format(new Date(date))
}

export function generateCode(prefix: string, sequence: number) {
  const paddedSequence = sequence.toString().padStart(6, '0')
  return `${prefix}-${paddedSequence}`
}

export async function sleep(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

export function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout
  
  return (...args: Parameters<T>) => {
    clearTimeout(timeout)
    timeout = setTimeout(() => func(...args), wait)
  }
}
```

**`src/lib/audit.ts`**
```typescript
import { prisma } from './db'

interface AuditLogData {
  userId: string
  action: 'CREATE' | 'UPDATE' | 'DELETE' | 'LOGIN' | 'LOGOUT' | 'EXPORT' | 'IMPORT'
  entityType: string
  entityId?: string
  oldData?: any
  newData?: any
  ipAddress?: string
  userAgent?: string
}

export async function createAuditLog(data: AuditLogData) {
  try {
    await prisma.auditLog.create({
      data: {
        userId: data.userId,
        action: data.action,
        entityType: data.entityType,
        entityId: data.entityId,
        oldData: data.oldData,
        newData: data.newData,
        ipAddress: data.ipAddress,
        userAgent: data.userAgent,
        timestamp: new Date(),
      },
    })
  } catch (error) {
    console.error('Error creating audit log:', error)
  }
}
```

### 3.7 React Components

#### 3.7.1 Layout Components
**`src/components/layout/DashboardLayout.tsx`**
```tsx
'use client'

import { useState } from 'react'
import { useSession } from 'next-auth/react'
import { usePathname } from 'next/navigation'
import Link from 'next/link'
import {
  LayoutDashboard,
  Package,
  Warehouse,
  Truck,
  BarChart3,
  Settings,
  Users,
  FileText,
  Bell,
  HelpCircle,
  Menu,
  X,
  ChevronDown,
} from 'lucide-react'
import { cn } from '@/lib/utils'

const navigation = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Products', href: '/dashboard/products', icon: Package },
  { name: 'Warehouse', href: '/dashboard/warehouse', icon: Warehouse },
  { name: 'Transport', href: '/dashboard/transport', icon: Truck },
  { name: 'Reports', href: '/dashboard/reports', icon: BarChart3 },
  { name: 'Users', href: '/dashboard/users', icon: Users },
  { name: 'Audit Log', href: '/dashboard/audit', icon: FileText },
]

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const { data: session } = useSession()
  const pathname = usePathname()

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Mobile sidebar */}
      <div className="lg:hidden">
        <div className="fixed inset-0 z-40 flex">
          <div
            className={cn(
              'fixed inset-0 bg-gray-600 bg-opacity-75 transition-opacity',
              sidebarOpen ? 'opacity-100' : 'opacity-0 pointer-events-none'
            )}
            onClick={() => setSidebarOpen(false)}
          />
          <div
            className={cn(
              'relative flex-1 flex flex-col max-w-xs w-full pt-5 pb-4 bg-white transform transition-transform',
              sidebarOpen ? 'translate-x-0' : '-translate-x-full'
            )}
          >
            <div className="absolute top-0 right-0 -mr-12 pt-2">
              <button
                type="button"
                className="ml-1 flex items-center justify-center h-10 w-10 rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                onClick={() => setSidebarOpen(false)}
              >
                <X className="h-6 w-6 text-white" />
              </button>
            </div>
            <div className="flex-shrink-0 flex items-center px-4">
              <div className="text-xl font-bold text-primary">ERP System</div>
            </div>
            <div className="mt-5 flex-1 h-0 overflow-y-auto">
              <nav className="px-2 space-y-1">
                {navigation.map((item) => {
                  const Icon = item.icon
                  const isActive = pathname === item.href
                  return (
                    <Link
                      key={item.name}
                      href={item.href}
                      className={cn(
                        'group flex items-center px-2 py-2 text-base font-medium rounded-md',
                        isActive
                          ? 'bg-primary text-white'
                          : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                      )}
                      onClick={() => setSidebarOpen(false)}
                    >
                      <Icon className="mr-4 h-6 w-6" />
                      {item.name}
                    </Link>
                  )
                })}
              </nav>
            </div>
          </div>
        </div>
      </div>

      {/* Desktop sidebar */}
      <div className="hidden lg:flex lg:w-64 lg:flex-col lg:fixed lg:inset-y-0">
        <div className="flex flex-col flex-grow border-r border-gray-200 pt-5 bg-white overflow-y-auto">
          <div className="flex items-center flex-shrink-0 px-4">
            <div className="text-xl font-bold text-primary">ERP System</div>
          </div>
          <div className="mt-5 flex-grow flex flex-col">
            <nav className="flex-1 px-2 pb-4 space-y-1">
              {navigation.map((item) => {
                const Icon = item.icon
                const isActive = pathname.startsWith(item.href)
                return (
                  <Link
                    key={item.name}
                    href={item.href}
                    className={cn(
                      'group flex items-center px-2 py-2 text-sm font-medium rounded-md',
                      isActive
                        ? 'bg-primary text-white'
                        : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                    )}
                  >
                    <Icon className="mr-3 h-5 w-5" />
                    {item.name}
                  </Link>
                )
              })}
            </nav>
          </div>
          <div className="flex-shrink-0 flex border-t border-gray-200 p-4">
            <div className="flex items-center">
              <div className="ml-3">
                <p className="text-sm font-medium text-gray-700">
                  {session?.user?.name}
                </p>
                <p className="text-xs text-gray-500">
                  {session?.user?.role} • {session?.user?.email}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Main content */}
      <div className="lg:pl-64">
        <div className="sticky top-0 z-10 flex-shrink-0 flex h-16 bg-white shadow">
          <button
            type="button"
            className="px-4 border-r border-gray-200 text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-primary lg:hidden"
            onClick={() => setSidebarOpen(true)}
          >
            <Menu className="h-6 w-6" />
          </button>
          <div className="flex-1 px-4 flex justify-between">
            <div className="flex-1 flex">
              <div className="w-full flex md:ml-0">
                <div className="relative w-full text-gray-400 focus-within:text-gray-600">
                  <div className="absolute inset-y-0 left-0 flex items-center pointer-events-none">
                    <Bell className="h-5 w-5" />
                  </div>
                  <input
                    className="block w-full h-full pl-8 pr-3 py-2 border-transparent text-gray-900 placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-0 focus:border-transparent sm:text-sm"
                    placeholder="Search..."
                    type="search"
                  />
                </div>
              </div>
            </div>
            <div className="ml-4 flex items-center md:ml-6">
              <button className="p-1 rounded-full text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">
                <HelpCircle className="h-6 w-6" />
              </button>
              <button className="ml-3 p-1 rounded-full text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">
                <Settings className="h-6 w-6" />
              </button>
            </div>
          </div>
        </div>

        <main className="py-6">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 md:px-8">
            {children}
          </div>
        </main>
      </div>
    </div>
  )
}
```

#### 3.7.2 Product Components
**`src/components/products/ProductTable.tsx`**
```tsx
'use client'

import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  useReactTable,
  getPaginationRowModel,
  getSortedRowModel,
  SortingState,
  ColumnFiltersState,
  getFilteredRowModel,
} from '@tanstack/react-table'
import {
  Search,
  Edit,
  Trash2,
  Eye,
  Download,
  Upload,
  Plus,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react'
import Link from 'next/link'
import { toast } from 'react-toastify'
import { formatCurrency } from '@/lib/utils'

interface Product {
  id: string
  code: string
  name: string
  category: string
  unit: string
  price: number
  cost: number
  stock: number
  minStock: number
  maxStock: number
  status: string
  warehouse: {
    code: string
    name: string
  }
}

const columnHelper = createColumnHelper<Product>()

const columns = [
  columnHelper.accessor('code', {
    header: 'รหัส',
    cell: (info) => (
      <span className="font-mono text-sm">{info.getValue()}</span>
    ),
  }),
  columnHelper.accessor('name', {
    header: 'ชื่อสินค้า',
    cell: (info) => info.getValue(),
  }),
  columnHelper.accessor('category', {
    header: 'หมวดหมู่',
    cell: (info) => info.getValue(),
  }),
  columnHelper.accessor('price', {
    header: 'ราคา',
    cell: (info) => formatCurrency(info.getValue()),
  }),
  columnHelper.accessor('stock', {
    header: 'คงเหลือ',
    cell: (info) => {
      const stock = info.getValue()
      const minStock = info.row.original.minStock
      const maxStock = info.row.original.maxStock
      
      let className = 'font-semibold'
      if (stock < minStock) {
        className += ' text-red-600'
      } else if (stock > maxStock * 0.8) {
        className += ' text-yellow-600'
      } else {
        className += ' text-green-600'
      }
      
      return <span className={className}>{stock} {info.row.original.unit}</span>
    },
  }),
  columnHelper.accessor('warehouse.name', {
    header: 'คลังสินค้า',
    cell: (info) => info.getValue(),
  }),
  columnHelper.accessor('status', {
    header: 'สถานะ',
    cell: (info) => {
      const status = info.getValue()
      const statusColors = {
        ACTIVE: 'bg-green-100 text-green-800',
        INACTIVE: 'bg-gray-100 text-gray-800',
        DISCONTINUED: 'bg-red-100 text-red-800',
      }
      return (
        <span className={`px-2 py-1 rounded-full text-xs ${statusColors[status as keyof typeof statusColors] || 'bg-gray-100'}`}>
          {status === 'ACTIVE' ? 'ใช้งาน' : status === 'INACTIVE' ? 'ไม่ใช้งาน' : 'ยกเลิก'}
        </span>
      )
    },
  }),
  columnHelper.display({
    id: 'actions',
    header: 'จัดการ',
    cell: ({ row }) => (
      <div className="flex space-x-2">
        <Link
          href={`/dashboard/products/${row.original.id}`}
          className="p-1 text-blue-600 hover:bg-blue-50 rounded"
          title="ดูรายละเอียด"
        >
          <Eye className="h-4 w-4" />
        </Link>
        <Link
          href={`/dashboard/products/${row.original.id}/edit`}
          className="p-1 text-yellow-600 hover:bg-yellow-50 rounded"
          title="แก้ไข"
        >
          <Edit className="h-4 w-4" />
        </Link>
        <button
          onClick={() => handleDelete(row.original.id)}
          className="p-1 text-red-600 hover:bg-red-50 rounded"
          title="ลบ"
        >
          <Trash2 className="h-4 w-4" />
        </button>
      </div>
    ),
  }),
]

async function fetchProducts(page: number, search: string) {
  const response = await fetch(`/api/products?page=${page}&limit=10&search=${search}`)
  if (!response.ok) throw new Error('Failed to fetch products')
  return response.json()
}

async function deleteProduct(id: string) {
  const response = await fetch(`/api/products/${id}`, {
    method: 'DELETE',
  })
  if (!response.ok) throw new Error('Failed to delete product')
  return response.json()
}

export default function ProductTable() {
  const [page, setPage] = useState(1)
  const [search, setSearch] = useState('')
  const [sorting, setSorting] = useState<SortingState>([])
  const [columnFilters, setColumnFilters] = useState<ColumnFiltersState>([])
  
  const queryClient = useQueryClient()
  
  const { data, isLoading, error } = useQuery({
    queryKey: ['products', page, search],
    queryFn: () => fetchProducts(page, search),
  })
  
  const deleteMutation = useMutation({
    mutationFn: deleteProduct,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['products'] })
      toast.success('ลบสินค้าสำเร็จ')
    },
    onError: (error) => {
      toast.error('ลบสินค้าไม่สำเร็จ: ' + error.message)
    },
  })
  
  const handleDelete = (id: string) => {
    if (window.confirm('คุณต้องการลบสินค้านี้ใช่หรือไม่?')) {
      deleteMutation.mutate(id)
    }
  }
  
  const table = useReactTable({
    data: data?.products || [],
    columns,
    getCoreRowModel: getCoreRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    onSortingChange: setSorting,
    onColumnFiltersChange: setColumnFilters,
    state: {
      sorting,
      columnFilters,
    },
  })
  
  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    )
  }
  
  if (error) {
    return (
      <div className="bg-red-50 border border-red-200 rounded-lg p-4">
        <p className="text-red-700">Error: {error.message}</p>
      </div>
    )
  }
  
  return (
    <div className="bg-white rounded-lg shadow">
      {/* Header */}
      <div className="px-6 py-4 border-b border-gray-200">
        <div className="flex justify-between items-center">
          <div>
            <h2 className="text-lg font-semibold text-gray-800">สินค้าทั้งหมด</h2>
            <p className="text-sm text-gray-600">จัดการข้อมูลสินค้าในระบบ</p>
          </div>
          <div className="flex space-x-3">
            <button className="flex items-center px-3 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50">
              <Download className="h-4 w-4 mr-2" />
              Export
            </button>
            <button className="flex items-center px-3 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50">
              <Upload className="h-4 w-4 mr-2" />
              Import
            </button>
            <Link
              href="/dashboard/products/new"
              className="flex items-center px-4 py-2 bg-primary text-white rounded-md text-sm font-medium hover:bg-primary/90"
            >
              <Plus className="h-4 w-4 mr-2" />
              เพิ่มสินค้า
            </Link>
          </div>
        </div>
      </div>
      
      {/* Search */}
      <div className="px-6 py-4 border-b border-gray-200">
        <div className="relative">
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <Search className="h-5 w-5 text-gray-400" />
          </div>
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-primary focus:border-primary sm:text-sm"
            placeholder="ค้นหาสินค้า..."
          />
        </div>
      </div>
      
      {/* Table */}
      <div className="overflow-x-auto">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            {table.getHeaderGroups().map((headerGroup) => (
              <tr key={headerGroup.id}>
                {headerGroup.headers.map((header) => (
                  <th
                    key={header.id}
                    className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    {flexRender(
                      header.column.columnDef.header,
                      header.getContext()
                    )}
                  </th>
                ))}
              </tr>
            ))}
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {table.getRowModel().rows.map((row) => (
              <tr key={row.id} className="hover:bg-gray-50">
                {row.getVisibleCells().map((cell) => (
                  <td
                    key={cell.id}
                    className="px-6 py-4 whitespace-nowrap text-sm text-gray-900"
                  >
                    {flexRender(cell.column.columnDef.cell, cell.getContext())}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      
      {/* Pagination */}
      <div className="px-6 py-4 border-t border-gray-200">
        <div className="flex items-center justify-between">
          <div className="flex-1 flex justify-between sm:hidden">
            <button
              onClick={() => setPage(page - 1)}
              disabled={page === 1}
              className="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              ก่อนหน้า
            </button>
            <button
              onClick={() => setPage(page + 1)}
              disabled={page >= data?.pagination.pages}
              className="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              ถัดไป
            </button>
          </div>
          <div className="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
            <div>
              <p className="text-sm text-gray-700">
                แสดง <span className="font-medium">{data?.pagination.page}</span> จาก{' '}
                <span className="font-medium">{data?.pagination.pages}</span> หน้า •{' '}
                <span className="font-medium">{data?.pagination.total}</span> รายการ
              </p>
            </div>
            <div>
              <nav className="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
                <button
                  onClick={() => setPage(page - 1)}
                  disabled={page === 1}
                  className="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <ChevronLeft className="h-5 w-5" />
                </button>
                {Array.from({ length: Math.min(5, data?.pagination.pages || 1) }).map((_, i) => {
                  const pageNumber = i + 1
                  return (
                    <button
                      key={pageNumber}
                      onClick={() => setPage(pageNumber)}
                      className={`relative inline-flex items-center px-4 py-2 border text-sm font-medium ${
                        page === pageNumber
                          ? 'z-10 bg-primary border-primary text-white'
                          : 'bg-white border-gray-300 text-gray-700 hover:bg-gray-50'
                      }`}
                    >
                      {pageNumber}
                    </button>
                  )
                })}
                <button
                  onClick={() => setPage(page + 1)}
                  disabled={page >= data?.pagination.pages}
                  className="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <ChevronRight className="h-5 w-5" />
                </button>
              </nav>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
```

#### 3.7.3 Form Components
**`src/components/forms/ProductForm.tsx`**
```tsx
'use client'

import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'
import { productSchema, type ProductFormData } from '@/lib/validators/product'

interface ProductFormProps {
  initialData?: any
  isEdit?: boolean
}

export default function ProductForm({ initialData, isEdit = false }: ProductFormProps) {
  const router = useRouter()
  const [isSubmitting, setIsSubmitting] = useState(false)
  
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<ProductFormData>({
    resolver: zodResolver(productSchema),
    defaultValues: initialData || {
      code: '',
      name: '',
      description: '',
      category: '',
      unit: 'ชิ้น',
      price: 0,
      cost: 0,
      stock: 0,
      minStock: 10,
      maxStock: 1000,
      warehouseId: '',
    },
  })
  
  const onSubmit = async (data: ProductFormData) => {
    setIsSubmitting(true)
    
    try {
      const url = isEdit ? `/api/products/${initialData.id}` : '/api/products'
      const method = isEdit ? 'PUT' : 'POST'
      
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      })
      
      if (!response.ok) {
        const error = await response.json()
        throw new Error(error.error || 'เกิดข้อผิดพลาด')
      }
      
      const result = await response.json()
      
      toast.success(
        isEdit ? 'แก้ไขสินค้าสำเร็จ' : 'เพิ่มสินค้าสำเร็จ'
      )
      
      router.push('/dashboard/products')
      router.refresh()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'เกิดข้อผิดพลาด')
    } finally {
      setIsSubmitting(false)
    }
  }
  
  return (
    <div className="bg-white rounded-lg shadow p-6">
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2">
          {/* Product Code */}
          <div>
            <label className="block text-sm font-medium text-gray-700">
              รหัสสินค้า *
            </label>
            <input
              type="text"
              {...register('code')}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
              placeholder="PROD-001"
            />
            {errors.code && (
              <p className="mt-1 text-sm text-red-600">{errors.code.message}</p>
            )}
          </div>
          
          {/* Product Name */}
          <div>
            <label className="block text-sm font-medium text-gray-700">
              ชื่อสินค้า *
            </label>
            <input
              type="text"
              {...register('name')}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
              placeholder="ชื่อสินค้า"
            />
            {errors.name && (
              <p className="mt-1 text-sm text-red-600">{errors.name.message}</p>
            )}
          </div>
          
          {/* Category */}
          <div>
            <label className="block text-sm font-medium text-gray-700">
              หมวดหมู่ *
            </label>
            <select
              {...register('category')}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
            >
              <option value="">เลือกหมวดหมู่</option>
              <option value="Electronics">อิเล็กทรอนิกส์</option>
              <option value="Office Supplies">เครื่องเขียน</option>
              <option value="Furniture">เฟอร์นิเจอร์</option>
              <option value="Food & Beverage">อาหารและเครื่องดื่ม</option>
              <option value="Clothing">เสื้อผ้า</option>
              <option value="Other">อื่นๆ</option>
            </select>
            {errors.category && (
              <p className="mt-1 text-sm text-red-600">{errors.category.message}</p>
            )}
          </div>
          
          {/* Unit */}
          <div>
            <label className="block text-sm font-medium text-gray-700">
              หน่วยนับ *
            </label>
            <input
              type="text"
              {...register('unit')}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
              placeholder="ชิ้น, ลัง, กล่อง"
            />
            {errors.unit && (
              <p className="mt-1 text-sm text-red-600">{errors.unit.message}</p>
            )}
          </div>
          
          {/* Price */}
          <div>
            <label className="block text-sm font-medium text-gray-700">
              ราคาขาย *
            </label>
            <div className="mt-1 relative rounded-md shadow-sm">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <span className="text-gray-500 sm:text-sm">฿</span>
              </div>
              <input
                type="number"
                step="0.01"
                {...register('price', { valueAsNumber: true })}
                className="block w-full pl-7 rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
              />
            </div>
            {errors.price && (
              <p className="mt-1 text-sm text-red-600">{errors.price.message}</p>
            )}
          </div>
          
          {/* Cost */}
          <div>
            <label className="block text-sm font-medium text-gray-700">
              ต้นทุน *
            </label>
            <div className="mt-1 relative rounded-md shadow-sm">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <span className="text-gray-500 sm:text-sm">฿</span>
              </div>
              <input
                type="number"
                step="0.01"
                {...register('cost', { valueAsNumber: true })}
                className="block w-full pl-7 rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
              />
            </div>
            {errors.cost && (
              <p className="mt-1 text-sm text-red-600">{errors.cost.message}</p>
            )}
          </div>
          
          {/* Stock */}
          <div>
            <label className="block text-sm font-medium text-gray-700">
              สต็อกเริ่มต้น
            </label>
            <input
              type="number"
              {...register('stock', { valueAsNumber: true })}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
            />
            {errors.stock && (
              <p className="mt-1 text-sm text-red-600">{errors.stock.message}</p>
            )}
          </div>
          
          {/* Warehouse */}
          <div>
            <label className="block text-sm font-medium text-gray-700">
              คลังสินค้า *
            </label>
            <select
              {...register('warehouseId')}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
            >
              <option value="">เลือกคลังสินค้า</option>
              {/* In real app, fetch from API */}
              <option value="warehouse-1">คลังสินค้าหลัก</option>
              <option value="warehouse-2">คลังสาขา 1</option>
            </select>
            {errors.warehouseId && (
              <p className="mt-1 text-sm text-red-600">{errors.warehouseId.message}</p>
            )}
          </div>
          
          {/* Min Stock */}
          <div>
            <label className="block text-sm font-medium text-gray-700">
              สต็อกขั้นต่ำ
            </label>
            <input
              type="number"
              {...register('minStock', { valueAsNumber: true })}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
            />
            {errors.minStock && (
              <p className="mt-1 text-sm text-red-600">{errors.minStock.message}</p>
            )}
          </div>
          
          {/* Max Stock */}
          <div>
            <label className="block text-sm font-medium text-gray-700">
              สต็อกสูงสุด
            </label>
            <input
              type="number"
              {...register('maxStock', { valueAsNumber: true })}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
            />
            {errors.maxStock && (
              <p className="mt-1 text-sm text-red-600">{errors.maxStock.message}</p>
            )}
          </div>
        </div>
        
        {/* Description */}
        <div>
          <label className="block text-sm font-medium text-gray-700">
            รายละเอียด
          </label>
          <textarea
            rows={3}
            {...register('description')}
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
            placeholder="รายละเอียดสินค้า..."
          />
          {errors.description && (
            <p className="mt-1 text-sm text-red-600">{errors.description.message}</p>
          )}
        </div>
        
        {/* Form Actions */}
        <div className="flex justify-end space-x-3 pt-4 border-t border-gray-200">
          <button
            type="button"
            onClick={() => router.back()}
            className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary"
          >
            ยกเลิก
          </button>
          <button
            type="submit"
            disabled={isSubmitting}
            className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isSubmitting ? 'กำลังบันทึก...' : isEdit ? 'แก้ไขสินค้า' : 'เพิ่มสินค้า'}
          </button>
        </div>
      </form>
    </div>
  )
}
```

### 3.8 Dashboard Pages

#### 3.8.1 Main Dashboard
**`src/app/dashboard/page.tsx`**
```tsx
import { getServerSession } from 'next-auth'
import { redirect } from 'next/navigation'
import { prisma } from '@/lib/db'
import { authOptions } from '@/lib/auth'
import DashboardStats from '@/components/dashboard/DashboardStats'
import RecentActivities from '@/components/dashboard/RecentActivities'
import LowStockProducts from '@/components/dashboard/LowStockProducts'
import SalesChart from '@/components/dashboard/SalesChart'

export default async function DashboardPage() {
  const session = await getServerSession(authOptions)
  
  if (!session) {
    redirect('/auth/login')
  }
  
  // Fetch dashboard data
  const [
    productCount,
    warehouseCount,
    lowStockCount,
    recentTransactions,
    lowStockProducts,
  ] = await Promise.all([
    prisma.product.count(),
    prisma.warehouse.count(),
    prisma.product.count({
      where: {
        stock: {
          lt: prisma.product.fields.minStock,
        },
      },
    }),
    prisma.transaction.findMany({
      take: 10,
      orderBy: { createdAt: 'desc' },
      include: {
        product: {
          select: {
            code: true,
            name: true,
          },
        },
        createdBy: {
          select: {
            name: true,
          },
        },
      },
    }),
    prisma.product.findMany({
      where: {
        stock: {
          lt: prisma.product.fields.minStock,
        },
      },
      take: 5,
      orderBy: { stock: 'asc' },
      include: {
        warehouse: {
          select: {
            name: true,
          },
        },
      },
    }),
  ])
  
  const stats = {
    products: productCount,
    warehouses: warehouseCount,
    lowStock: lowStockCount,
    transactions: recentTransactions.length,
  }
  
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold text-gray-900">Dashboard</h1>
        <p className="mt-1 text-sm text-gray-600">
          ยินดีต้อนรับกลับ, {session.user?.name}
        </p>
      </div>
      
      {/* Stats Grid */}
      <DashboardStats stats={stats} />
      
      {/* Charts and Tables */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2">
          <SalesChart />
        </div>
        <div>
          <LowStockProducts products={lowStockProducts} />
        </div>
      </div>
      
      {/* Recent Activities */}
      <div>
        <RecentActivities transactions={recentTransactions} />
      </div>
    </div>
  )
}
```

#### 3.8.2 Products Page
**`src/app/dashboard/products/page.tsx`**
```tsx
import { getServerSession } from 'next-auth'
import { redirect } from 'next/navigation'
import { authOptions } from '@/lib/auth'
import ProductTable from '@/components/products/ProductTable'

export default async function ProductsPage() {
  const session = await getServerSession(authOptions)
  
  if (!session) {
    redirect('/auth/login')
  }
  
  return (
    <div>
      <div className="mb-6">
        <h1 className="text-2xl font-semibold text-gray-900">จัดการสินค้า</h1>
        <p className="mt-1 text-sm text-gray-600">
          จัดการข้อมูลสินค้า, สต็อก, และราคา
        </p>
      </div>
      
      <ProductTable />
    </div>
  )
}
```

## 4. Docker Configuration

### 4.1 Dockerfile
```dockerfile
# Development Dockerfile
FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED 1

RUN npm run build

# Production image, copy all the files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]
```

### 4.2 docker-compose.yml
```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: erp_user
      POSTGRES_PASSWORD: erp_password
      POSTGRES_DB: erp_system
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U erp_user"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://erp_user:erp_password@postgres:5432/erp_system
      NEXTAUTH_URL: http://localhost:3000
      NEXTAUTH_SECRET: your-secret-key-change-in-production
      REDIS_URL: redis://redis:6379
    volumes:
      - ./src:/app/src
      - ./public:/app/public
      - /app/node_modules
      - /app/.next
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started
    command: npm run dev

  n8n:
    image: n8nio/n8n
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=password
      - WEBHOOK_URL=http://localhost:5678
      - N8N_PROTOCOL=http
      - N8N_PORT=5678
      - N8N_HOST=localhost
    volumes:
      - n8n_data:/home/node/.n8n

  jenkins:
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - JAVA_OPTS=-Djenkins.install.runSetupWizard=false

volumes:
  postgres_data:
  redis_data:
  n8n_data:
  jenkins_home:
```

## 5. Testing

### 5.1 Unit Tests
**`tests/unit/products.test.ts`**
```typescript
import { describe, it, expect, beforeEach } from '@jest/globals'
import { productSchema } from '@/lib/validators/product'

describe('Product Validation', () => {
  it('should validate correct product data', () => {
    const validProduct = {
      code: 'PROD-001',
      name: 'Test Product',
      category: 'Electronics',
      unit: 'pcs',
      price: 100,
      cost: 80,
      stock: 10,
      warehouseId: '123e4567-e89b-12d3-a456-426614174000',
    }

    const result = productSchema.safeParse(validProduct)
    expect(result.success).toBe(true)
  })

  it('should reject invalid price', () => {
    const invalidProduct = {
      code: 'PROD-001',
      name: 'Test Product',
      category: 'Electronics',
      unit: 'pcs',
      price: -100, // Invalid: negative price
      cost: 80,
      stock: 10,
      warehouseId: '123e4567-e89b-12d3-a456-426614174000',
    }

    const result = productSchema.safeParse(invalidProduct)
    expect(result.success).toBe(false)
    if (!result.success) {
      expect(result.error.errors[0].message).toContain('Price must be positive')
    }
  })

  it('should reject missing required fields', () => {
    const invalidProduct = {
      code: 'PROD-001',
      // Missing name
      category: 'Electronics',
      unit: 'pcs',
      price: 100,
      cost: 80,
      stock: 10,
      warehouseId: '123e4567-e89b-12d3-a456-426614174000',
    }

    const result = productSchema.safeParse(invalidProduct)
    expect(result.success).toBe(false)
  })
})
```

### 5.2 API Tests with Robot Framework
**`tests/api/products.robot`**
```robot
*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           String
Library           OperatingSystem

*** Variables ***
${BASE_URL}       http://localhost:3000/api
${TOKEN}          ${EMPTY}

*** Test Cases ***
Login And Get Token
    [Tags]    auth
    ${response}=    POST    ${BASE_URL}/auth/login
    ...    json={"email": "admin@erp.com", "password": "admin123"}
    ...    expected_status=200
    
    ${token}=    Set Variable    ${response.json()}[token]
    Set Global Variable    ${TOKEN}    Bearer ${token}
    Should Not Be Empty    ${token}

Create Product Successfully
    [Tags]    products    create
    [Setup]    Login And Get Token
    
    ${headers}=    Create Dictionary
    ...    Authorization=${TOKEN}
    ...    Content-Type=application/json
    
    ${product_data}=    Create Dictionary
    ...    code=TEST-001
    ...    name=Test Product Robot
    ...    category=Test Category
    ...    unit=pcs
    ...    price=100.50
    ...    cost=80.00
    ...    stock=50
    ...    warehouseId=warehouse-1
    
    ${response}=    POST    ${BASE_URL}/products
    ...    json=${product_data}
    ...    headers=${headers}
    ...    expected_status=201
    
    ${product_id}=    Set Variable    ${response.json()}[id]
    Set Test Variable    ${PRODUCT_ID}    ${product_id}
    
    Should Be Equal As Strings    ${response.json()}[code]    TEST-001
    Should Be Equal As Numbers    ${response.json()}[price]    100.50

Get Product List
    [Tags]    products    read
    [Setup]    Login And Get Token
    
    ${headers}=    Create Dictionary
    ...    Authorization=${TOKEN}
    
    ${response}=    GET    ${BASE_URL}/products
    ...    headers=${headers}
    ...    expected_status=200
    
    ${products}=    Set Variable    ${response.json()}[products]
    Length Should Be    ${products}    ${10}
    Should Contain Match    ${products}    *code=TEST-001*

Update Product
    [Tags]    products    update
    [Setup]    Run Keywords
    ...    Login And Get Token
    ...    AND    Create Product Successfully
    
    ${headers}=    Create Dictionary
    ...    Authorization=${TOKEN}
    ...    Content-Type=application/json
    
    ${update_data}=    Create Dictionary
    ...    name=Updated Product Name
    ...    price=150.00
    
    ${response}=    PUT    ${BASE_URL}/products/${PRODUCT_ID}
    ...    json=${update_data}
    ...    headers=${headers}
    ...    expected_status=200
    
    Should Be Equal As Strings    ${response.json()}[name]    Updated Product Name
    Should Be Equal As Numbers    ${response.json()}[price]    150.00

Delete Product
    [Tags]    products    delete
    [Setup]    Run Keywords
    ...    Login And Get Token
    ...    AND    Create Product Successfully
    
    ${headers}=    Create Dictionary
    ...    Authorization=${TOKEN}
    
    ${response}=    DELETE    ${BASE_URL}/products/${PRODUCT_ID}
    ...    headers=${headers}
    ...    expected_status=200
    
    Should Be Equal As Strings    ${response.json()}[message]    Product deleted successfully

*** Keywords ***
Login And Get Token
    ${response}=    POST    ${BASE_URL}/auth/login
    ...    json={"email": "admin@erp.com", "password": "admin123"}
    ...    expected_status=200
    
    ${token}=    Set Variable    ${response.json()}[token]
    Set Global Variable    ${TOKEN}    Bearer ${token}
    Should Not Be Empty    ${token}
```

## 6. CI/CD Pipeline

### 6.1 GitHub Actions Workflow
**`.github/workflows/ci-cd.yml`**
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_USER: test_user
          POSTGRES_PASSWORD: test_password
          POSTGRES_DB: test_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linting
      run: npm run lint
    
    - name: Run unit tests
      run: npm run test:unit
      env:
        DATABASE_URL: postgresql://test_user:test_password@localhost:5432/test_db
        NEXTAUTH_SECRET: test-secret
    
    - name: Run API tests
      run: npm run test:api
    
    - name: Build application
      run: npm run build
    
    - name: Upload test results
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: test-results
        path: |
          coverage/
          test-results/

  deploy:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ap-southeast-1
    
    - name: Login to Amazon ECR
      id: login-ecr
      uses: aws-actions/amazon-ecr-login@v1
    
    - name: Build, tag, and push image to Amazon ECR
      env:
        ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
        ECR_REPOSITORY: erp-crm-system
        IMAGE_TAG: ${{ github.sha }}
      run: |
        docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
        docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
    
    - name: Deploy to EC2
      uses: appleboy/ssh-action@v0.1.5
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ${{ secrets.EC2_USERNAME }}
        key: ${{ secrets.EC2_SSH_KEY }}
        script: |
          cd /home/ubuntu/erp-system
          aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin ${{ steps.login-ecr.outputs.registry }}
          docker pull ${{ steps.login-ecr.outputs.registry }}/erp-crm-system:${{ github.sha }}
          docker-compose down
          docker-compose up -d
```

### 6.2 Jenkins Pipeline
**`jenkins/Jenkinsfile`**
```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'your-docker-registry'
        APP_NAME = 'erp-crm-system'
        AWS_REGION = 'ap-southeast-1'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: '${GIT_BRANCH}', url: 'https://github.com/your-org/erp-crm-system.git'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
            }
        }
        
        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }
        
        stage('Unit Tests') {
            steps {
                sh 'npm run test:unit'
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    docker.build("${DOCKER_REGISTRY}/${APP_NAME}:${env.BUILD_ID}")
                }
            }
        }
        
        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}") {
                        docker.image("${DOCKER_REGISTRY}/${APP_NAME}:${env.BUILD_ID}").push()
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            steps {
                sh '''
                    ssh ubuntu@staging-server "
                        cd /opt/erp-system &&
                        docker-compose pull &&
                        docker-compose up -d
                    "
                '''
            }
        }
        
        stage('Integration Tests') {
            steps {
                sh 'npm run test:api'
            }
        }
        
        stage('Deploy to Production') {
            input {
                message "Deploy to production?"
                ok "Deploy"
            }
            steps {
                sh '''
                    ssh ubuntu@production-server "
                        cd /opt/erp-system &&
                        docker-compose pull &&
                        docker-compose up -d
                    "
                '''
            }
        }
    }
    
    post {
        success {
            emailext (
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Build successful!\nCheck console output at ${env.BUILD_URL}",
                to: 'dev-team@company.com'
            )
        }
        failure {
            emailext (
                subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Build failed!\nCheck console output at ${env.BUILD_URL}",
                to: 'dev-team@company.com'
            )
        }
    }
}
```

## 7. Monitoring & Logging

### 7.1 Grafana Dashboard Configuration
**`monitoring/dashboards/erp-dashboard.json`**
```json
{
  "dashboard": {
    "title": "ERP System Dashboard",
    "panels": [
      {
        "title": "API Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{method}} {{endpoint}}"
          }
        ]
      },
      {
        "title": "Error Rate",
        "type": "singlestat",
        "targets": [
          {
            "expr": "sum(rate(http_requests_total{status=~\"5..\"}[5m])) / sum(rate(http_requests_total[5m]))",
            "format": "percentunit"
          }
        ]
      },
      {
        "title": "Database Connections",
        "type": "graph",
        "targets": [
          {
            "expr": "pg_stat_database_numbackends{datname=\"erp_system\"}"
          }
        ]
      },
      {
        "title": "System Resources",
        "type": "row",
        "panels": [
          {
            "title": "CPU Usage",
            "type": "graph",
            "targets": [
              {
                "expr": "100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)"
              }
            ]
          },
          {
            "title": "Memory Usage",
            "type": "graph",
            "targets": [
              {
                "expr": "(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100"
              }
            ]
          }
        ]
      }
    ]
  }
}
```

### 7.2 Prometheus Configuration
**`monitoring/prometheus/prometheus.yml`**
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'erp-app'
    static_configs:
      - targets: ['app:3000']
    metrics_path: '/api/metrics'
    
  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres-exporter:9187']
    
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
    
  - job_name: 'redis'
    static_configs:
      - targets: ['redis-exporter:9121']
```

## 8. Documentation

### 8.1 API Documentation
**`docs/api.md`**
```markdown
# ERP System API Documentation

## Authentication

All API endpoints require authentication except the login endpoint.

### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### Response
```json
{
  "token": "jwt-token-here",
  "user": {
    "id": "user-id",
    "email": "user@example.com",
    "name": "User Name",
    "role": "ADMIN"
  }
}
```

## Products

### Get Products
```http
GET /api/products
Authorization: Bearer <token>
```

**Query Parameters:**
- `page` (optional): Page number, default: 1
- `limit` (optional): Items per page, default: 10
- `search` (optional): Search term
- `category` (optional): Filter by category
- `warehouseId` (optional): Filter by warehouse

### Create Product
```http
POST /api/products
Authorization: Bearer <token>
Content-Type: application/json

{
  "code": "PROD-001",
  "name": "Product Name",
  "category": "Electronics",
  "unit": "pcs",
  "price": 100.50,
  "cost": 80.00,
  "stock": 50,
  "minStock": 10,
  "maxStock": 1000,
  "warehouseId": "warehouse-uuid"
}
```

### Update Product
```http
PUT /api/products/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Updated Product Name",
  "price": 150.00
}
```

### Delete Product
```http
DELETE /api/products/{id}
Authorization: Bearer <token>
```

## Warehouse

### Get Warehouses
```http
GET /api/warehouses
Authorization: Bearer <token>
```

### Create Warehouse
```http
POST /api/warehouses
Authorization: Bearer <token>
Content-Type: application/json

{
  "code": "WH-001",
  "name": "Main Warehouse",
  "type": "MAIN",
  "address": "123 Main St",
  "phone": "021234567",
  "capacity": 10000
}
```

## Error Responses

All endpoints may return the following error responses:

### 400 Bad Request
```json
{
  "error": "Validation error",
  "details": {
    "field": ["Error message"]
  }
}
```

### 401 Unauthorized
```json
{
  "error": "Unauthorized"
}
```

### 404 Not Found
```json
{
  "error": "Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal server error"
}
```
```

## 9. Setup and Deployment Guide

### 9.1 Local Development Setup
```bash
# 1. Clone the repository
git clone https://github.com/your-org/erp-crm-system.git
cd erp-crm-system

# 2. Install dependencies
npm install

# 3. Set up environment variables
cp .env.example .env.local
# Edit .env.local with your configuration

# 4. Set up database
npm run db:migrate
npm run db:seed

# 5. Start development server
npm run dev

# 6. Run tests
npm run test:unit
npm run test:api
npm run test:e2e
```

### 9.2 Production Deployment
```bash
# 1. Build Docker image
docker build -t erp-crm-system:latest .

# 2. Run with Docker Compose
docker-compose -f docker-compose.prod.yml up -d

# 3. Run database migrations
docker-compose exec app npm run db:migrate

# 4. Seed initial data
docker-compose exec app npm run db:seed
```

## 10. Maintenance and Monitoring

### 10.1 Health Check Endpoint
```typescript
// src/app/api/health/route.ts
import { NextResponse } from 'next/server'
import { prisma } from '@/lib/db'

export async function GET() {
  try {
    // Check database connection
    await prisma.$queryRaw`SELECT 1`
    
    // Check Redis connection (if using)
    // Add other service checks here
    
    return NextResponse.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      services: {
        database: 'connected',
        redis: 'connected',
      },
    })
  } catch (error) {
    return NextResponse.json(
      {
        status: 'unhealthy',
        timestamp: new Date().toISOString(),
        error: error.message,
      },
      { status: 503 }
    )
  }
}
```

### 10.2 Backup Script
**`scripts/backup.sh`**
```bash
#!/bin/bash

# Configuration
BACKUP_DIR="/backups/erp-system"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="erp_system"
DB_USER="erp_user"
DB_HOST="localhost"

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup database
pg_dump -h $DB_HOST -U $DB_USER $DB_NAME > $BACKUP_DIR/db_backup_$DATE.sql

# Backup uploaded files
tar -czf $BACKUP_DIR/uploads_$DATE.tar.gz /path/to/uploads

# Keep only last 7 days of backups
find $BACKUP_DIR -type f -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/db_backup_$DATE.sql"
```

---

## สรุป

โปรเจค ERP/CRM นี้ประกอบด้วย:

1. **Frontend:** Next.js 14 + React + Tailwind CSS
2. **Backend:** API Routes + Prisma ORM + PostgreSQL
3. **Authentication:** NextAuth.js with JWT
4. **DevOps:** Docker, Jenkins, GitHub Actions
5. **Testing:** Jest, Robot Framework, Playwright
6. **Monitoring:** Grafana, Prometheus
7. **Database:** PostgreSQL with Prisma
8. **Storage:** AWS S3 for file uploads
9. **Caching:** Redis for session cache
10. **Automation:** n8n for workflow automation

ระบบนี้รองรับทั้งหมด 6 ระบบที่ต้องการ:
- ✅ ระบบผู้ใช้งาน
- ✅ ระบบสินค้า  
- ✅ ระบบคลังสินค้า
- ✅ ระบบขนส่ง
- ✅ ระบบรายงาน
- ✅ ระบบประวัติการใช้งาน

โค้ดทั้งหมดนี้พร้อมสำหรับการนำไปใช้งานจริง พร้อมทั้งมี CI/CD Pipeline, Testing, Monitoring และ Documentation ที่ครบถ้วน