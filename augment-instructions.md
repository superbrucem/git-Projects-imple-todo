# Augment Code Instructions Template

## 🎯 Project Overview
**Project Name**: [Your Project Name]
**Project Type**: [Web App / API / Desktop App / Mobile App / Library]
**Description**: [Brief description of what you're building]

## 🔧 Technical Preferences

### Technology Stack
- **Frontend**: [React / Vue / Angular / Vanilla JS / etc.]
- **Backend**: [Node.js / Python / Java / .NET / etc.]
- **Database**: [PostgreSQL / MySQL / MongoDB / etc.]
- **Styling**: [CSS / SCSS / Tailwind / Styled Components / etc.]
- **Testing**: [Jest / Vitest / Cypress / Playwright / etc.]

### Code Style Preferences
```yaml
# Copy this section and customize
coding_style:
  language: "TypeScript"  # or JavaScript, Python, etc.
  formatting:
    - "Use Prettier with 2-space indentation"
    - "Single quotes for strings"
    - "Trailing commas where valid"
    - "Semicolons required"
  
  naming_conventions:
    - "camelCase for variables and functions"
    - "PascalCase for components and classes"
    - "UPPER_SNAKE_CASE for constants"
    - "kebab-case for file names"
  
  architecture:
    - "Functional components with hooks (React)"
    - "Custom hooks for reusable logic"
    - "Separate business logic from UI"
    - "Use TypeScript interfaces for data types"
  
  file_structure:
    - "Group by feature, not by file type"
    - "Index files for clean imports"
    - "Separate utils, hooks, and components"
    - "Co-locate tests with source files"
```

### Quality Standards
- **Code Coverage**: Minimum 80%
- **Performance**: Page load < 2 seconds
- **Accessibility**: WCAG 2.1 AA compliance
- **Browser Support**: Chrome 90+, Firefox 88+, Safari 14+

## 📋 Task List

### Phase 1: Foundation
- [ ] Set up project structure
- [ ] Configure development environment
- [ ] Set up linting and formatting
- [ ] Create basic documentation

### Phase 2: Core Features
- [ ] Implement authentication system
- [ ] Create main dashboard
- [ ] Add data management
- [ ] Set up API endpoints

### Phase 3: Enhancement
- [ ] Add testing suite
- [ ] Implement error handling
- [ ] Add performance optimizations
- [ ] Create deployment pipeline

## 🎨 Design Guidelines

### UI/UX Preferences
```yaml
design_system:
  colors:
    primary: "#2563EB"      # Blue
    secondary: "#059669"    # Green
    accent: "#DC2626"       # Red
    neutral: "#6B7280"      # Gray
  
  typography:
    font_family: "Inter, system-ui, sans-serif"
    headings: "Bold (700)"
    body: "Regular (400)"
    code: "JetBrains Mono, monospace"
  
  spacing:
    base_unit: "8px"
    container_max: "1200px"
    border_radius: "8px"
  
  components:
    buttons: "Rounded corners, hover states, focus rings"
    forms: "Clear labels, validation states, helpful errors"
    cards: "Subtle shadows, consistent padding"
    navigation: "Clear hierarchy, breadcrumbs where needed"
```

### Layout Preferences
- **Responsive Design**: Mobile-first approach
- **Grid System**: CSS Grid for layouts, Flexbox for components
- **Navigation**: Clean, minimal navigation with clear hierarchy
- **Forms**: Single-column layout, clear validation

### Footer & Contact Information
```yaml
footer_content:
  company_info:
    name: "[Your Company Name]"
    address: |
      [Street Address]
      [City, State ZIP Code]
      [Country]
    phone: "[Phone Number]"
    email: "[Contact Email]"
    website: "[Website URL]"

  footer_sections:
    - title: "Quick Links"
      links:
        - "About Us"
        - "Services"
        - "Contact"
        - "Privacy Policy"

    - title: "Support"
      links:
        - "Help Center"
        - "Documentation"
        - "Contact Support"
        - "System Status"

    - title: "Legal"
      links:
        - "Terms of Service"
        - "Privacy Policy"
        - "Cookie Policy"
        - "GDPR Compliance"

  footer_style:
    background_color: "#1F2937"  # Dark gray
    text_color: "#F9FAFB"        # Light gray
    link_color: "#60A5FA"        # Light blue
    border_top: "1px solid #374151"
    padding: "2rem 0"

  copyright_text: "© 2024 [Your Company Name]. All rights reserved."

  social_media:
    - platform: "LinkedIn"
      url: "[LinkedIn URL]"
      icon: "linkedin"
    - platform: "Twitter"
      url: "[Twitter URL]"
      icon: "twitter"
    - platform: "GitHub"
      url: "[GitHub URL]"
      icon: "github"
```

### Address Display Formats
```yaml
address_formats:
  # For contact pages
  full_address:
    format: |
      [Company Name]
      [Street Address]
      [City, State ZIP Code]
      [Country]

      Phone: [Phone Number]
      Email: [Email Address]

  # For footer (compact)
  footer_address:
    format: "[Street Address], [City, State ZIP] | Phone: [Phone] | Email: [Email]"

  # For business cards/headers
  header_address:
    format: "[City, State] | [Phone] | [Website]"

  # For invoices/formal documents
  formal_address:
    format: |
      [Company Name]
      [Street Address]
      [City, State ZIP Code]
      [Country]

      Tel: [Phone Number]
      Web: [Website URL]
      Email: [Email Address]
```

## � Content Requirements

### Required Content Elements
```yaml
mandatory_content:
  footer:
    always_include:
      - Company name and address
      - Contact information (phone, email)
      - Copyright notice with current year
      - Privacy policy link
      - Terms of service link

    conditional_include:
      - Social media links (if provided)
      - Newsletter signup (if applicable)
      - Site map links (for larger sites)
      - Accessibility statement

  contact_info:
    primary_address: |
      [Replace with your actual address]
      123 Main Street
      Suite 100
      City, State 12345
      United States

    mailing_address: |
      [If different from primary]
      P.O. Box 123
      City, State 12345
      United States

    contact_details:
      phone: "+1 (555) 123-4567"
      email: "contact@yourcompany.com"
      support_email: "support@yourcompany.com"
      business_hours: "Monday - Friday, 9:00 AM - 5:00 PM EST"

  legal_requirements:
    - "Include accessibility statement if required"
    - "Add GDPR compliance notice for EU users"
    - "Include cookie policy if using cookies"
    - "Add terms of service for user accounts"
```

### Content Style Guidelines
```yaml
content_style:
  tone: "Professional but friendly"
  voice: "Active voice preferred"
  formatting:
    - "Use consistent capitalization"
    - "Include proper punctuation"
    - "Use bullet points for lists"
    - "Keep paragraphs short and scannable"

  address_presentation:
    - "Use proper address formatting for region"
    - "Include country for international users"
    - "Make phone numbers clickable on mobile"
    - "Make email addresses clickable"
```

## �🚀 Automation Instructions

### When Creating Files:
1. **Always include proper TypeScript types**
2. **Add JSDoc comments for functions**
3. **Include error handling**
4. **Add basic tests alongside implementation**
5. **Follow the established file structure**

### When Making Changes:
1. **Update related tests**
2. **Update documentation if needed**
3. **Check for breaking changes**
4. **Maintain consistent code style**

### Don't Ask Me About:
- Code formatting (follow Prettier config)
- File naming (follow conventions above)
- Basic error handling patterns
- Standard TypeScript practices
- Common accessibility patterns

### Do Ask Me About:
- Business logic decisions
- Complex architectural choices
- External API integrations
- Performance trade-offs
- Security considerations

## 📝 Progress Tracking

### Completed Tasks
- [x] ~~Initial project setup~~ (2024-01-15)
- [x] ~~Basic component structure~~ (2024-01-16)

### Current Focus
- [ ] **IN PROGRESS**: User authentication system
  - [x] Login form component
  - [x] API integration
  - [ ] Password reset flow
  - [ ] Session management

### Next Up
- [ ] Dashboard layout
- [ ] Data visualization components
- [ ] API error handling

### Blockers/Questions
- [ ] **BLOCKED**: Need API endpoint specifications for user roles
- [ ] **QUESTION**: Should we use local storage or cookies for session?

## 🔄 Workflow Preferences

### Development Process
1. **Create feature branch** for each task
2. **Write tests first** (TDD approach)
3. **Implement feature** following style guide
4. **Update documentation** as needed
5. **Create pull request** with clear description

### Communication Style
- **Be direct and specific** in suggestions
- **Provide code examples** when explaining concepts
- **Explain the "why"** behind architectural decisions
- **Suggest alternatives** when there are trade-offs

## 📚 Reference Links
- [Project Repository]: [GitHub URL]
- [Design System]: [Figma/Design URL]
- [API Documentation]: [API Docs URL]
- [Deployment]: [Production URL]

---

## 💡 Usage Instructions

1. **Fill out this template** with your specific preferences
2. **Share it with Augment Code** at the start of your session
3. **Reference specific sections** when giving tasks
4. **Update the progress tracking** as work is completed
5. **Add new preferences** as they come up

### Example Usage:
```
"Following the augment-instructions.md file, create a user authentication 
component. Update the progress tracking when done."
```

This way, Augment Code has all your preferences upfront and can work 
autonomously while tracking progress!
