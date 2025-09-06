#!/bin/bash

# =============================================================================
# BMAD + Augment Instructions Helper Script
# =============================================================================
# Description: Helper script to work with BMAD methodology and Augment instructions
# Usage: ./bmad-augment-helper.sh [command] [options]
# =============================================================================

BMAD_FILE="bmad-augment-integration.md"
AUGMENT_FILE="augment-instructions.md"
TASKS_FILE="bmad-tasks.md"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

show_help() {
    echo -e "${CYAN}BMAD + Augment Instructions Helper${NC}"
    echo "===================================="
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  init                    Initialize BMAD + Augment workflow"
    echo "  create-task <name>      Create new BMAD-structured task"
    echo "  business <feature>      Show business context for feature"
    echo "  model <entity>          Show data model for entity"
    echo "  architecture <component> Show architecture for component"
    echo "  design <element>        Show design specs for element"
    echo "  validate                Validate alignment between documents"
    echo "  generate-prompt <task>  Generate Augment Code prompt for task"
    echo ""
    echo "Examples:"
    echo "  $0 create-task 'User Authentication'"
    echo "  $0 business 'login system'"
    echo "  $0 generate-prompt 'authentication component'"
}

init_workflow() {
    echo -e "${BLUE}🚀 Initializing BMAD + Augment Workflow${NC}"
    
    # Check if files exist
    if [ ! -f "$AUGMENT_FILE" ]; then
        echo -e "${RED}❌ $AUGMENT_FILE not found${NC}"
        echo "Please create your augment instructions file first"
        exit 1
    fi
    
    if [ ! -f "$BMAD_FILE" ]; then
        echo -e "${YELLOW}⚠️  $BMAD_FILE not found, creating from template${NC}"
        cp bmad-augment-integration.md "$BMAD_FILE" 2>/dev/null || {
            echo -e "${RED}❌ Template file not found${NC}"
            exit 1
        }
    fi
    
    # Create tasks file if it doesn't exist
    if [ ! -f "$TASKS_FILE" ]; then
        cat > "$TASKS_FILE" << 'EOF'
# BMAD-Structured Tasks

## Active Tasks

### Task Template
```markdown
## Task: [Feature Name]

### Business Context (B)
- **Business Value**: [Why this feature matters]
- **Success Metrics**: [How to measure success]
- **User Impact**: [How this affects users]

### Data Requirements (M)
- **Data Entities**: [What data is involved]
- **Business Rules**: [Validation and logic rules]
- **Privacy Considerations**: [Data protection requirements]

### Technical Implementation (A)
- **Architecture Pattern**: [How to build it]
- **Dependencies**: [What other components are needed]
- **Integration Points**: [How it connects to other parts]

### Design Specifications (D)
- **User Experience**: [How users interact with this]
- **Visual Design**: [UI specifications]
- **Accessibility**: [How to make it accessible]

### Status
- [ ] Business requirements defined
- [ ] Data model designed
- [ ] Architecture planned
- [ ] Design specifications created
- [ ] Implementation started
- [ ] Testing completed
- [ ] Documentation updated
```

## Completed Tasks
[Completed tasks will be moved here]
EOF
        echo -e "${GREEN}✅ Created $TASKS_FILE${NC}"
    fi
    
    echo -e "${GREEN}✅ BMAD + Augment workflow initialized${NC}"
    echo -e "${BLUE}📝 Next steps:${NC}"
    echo "1. Customize $BMAD_FILE with your project details"
    echo "2. Update $AUGMENT_FILE with your preferences"
    echo "3. Use 'create-task' to start adding features"
}

create_task() {
    local task_name="$1"
    if [ -z "$task_name" ]; then
        echo -e "${RED}❌ Task name required${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}📝 Creating BMAD task: $task_name${NC}"
    
    # Add task to tasks file
    cat >> "$TASKS_FILE" << EOF

## Task: $task_name
**Created**: $(date '+%Y-%m-%d %H:%M:%S')

### Business Context (B)
- **Business Value**: [Why this feature matters]
- **Success Metrics**: [How to measure success]
- **User Impact**: [How this affects users]

### Data Requirements (M)
- **Data Entities**: [What data is involved]
- **Business Rules**: [Validation and logic rules]
- **Privacy Considerations**: [Data protection requirements]

### Technical Implementation (A)
- **Architecture Pattern**: [How to build it - reference $AUGMENT_FILE]
- **Dependencies**: [What other components are needed]
- **Integration Points**: [How it connects to other parts]

### Design Specifications (D)
- **User Experience**: [How users interact with this]
- **Visual Design**: [UI specifications - reference $AUGMENT_FILE]
- **Accessibility**: [How to make it accessible]

### Implementation Notes
- **Code Style**: Follow $AUGMENT_FILE coding standards
- **Testing Strategy**: [How to test this feature]
- **Documentation**: [What documentation is needed]

### Status
- [ ] Business requirements defined
- [ ] Data model designed
- [ ] Architecture planned
- [ ] Design specifications created
- [ ] Implementation started
- [ ] Testing completed
- [ ] Documentation updated

---
EOF
    
    echo -e "${GREEN}✅ Task created in $TASKS_FILE${NC}"
    echo -e "${YELLOW}📋 Please edit the task with specific details${NC}"
}

show_business_context() {
    local feature="$1"
    echo -e "${GREEN}💼 Business Context for: $feature${NC}"
    echo "=================================="
    
    # Extract business model section from BMAD file
    sed -n '/### \*\*B - Business Model Layer\*\*/,/### \*\*M - Model/p' "$BMAD_FILE" | head -n -1
    
    echo -e "\n${BLUE}💡 Consider these questions:${NC}"
    echo "• What business problem does this solve?"
    echo "• How will success be measured?"
    echo "• What's the user impact?"
    echo "• How does this align with business goals?"
}

show_data_model() {
    local entity="$1"
    echo -e "${PURPLE}🗄️  Data Model for: $entity${NC}"
    echo "================================"
    
    # Extract model section from BMAD file
    sed -n '/### \*\*M - Model\/Data Architecture Layer\*\*/,/### \*\*A - Application/p' "$BMAD_FILE" | head -n -1
    
    echo -e "\n${BLUE}💡 Consider these questions:${NC}"
    echo "• What are the core entities?"
    echo "• How do they relate to each other?"
    echo "• What are the business rules?"
    echo "• What are the privacy requirements?"
}

show_architecture() {
    local component="$1"
    echo -e "${BLUE}🏗️  Architecture for: $component${NC}"
    echo "=================================="
    
    # Extract architecture section from BMAD file
    sed -n '/### \*\*A - Application Architecture Layer\*\*/,/### \*\*D - Design/p' "$BMAD_FILE" | head -n -1
    
    echo -e "\n${YELLOW}🔧 Technical Preferences from $AUGMENT_FILE:${NC}"
    grep -A 10 "### Technology Stack" "$AUGMENT_FILE" | head -10
}

show_design() {
    local element="$1"
    echo -e "${CYAN}🎨 Design Specifications for: $element${NC}"
    echo "======================================="
    
    # Extract design section from BMAD file
    sed -n '/### \*\*D - Design Layer\*\*/,/## 🔄 Integration Workflow/p' "$BMAD_FILE" | head -n -1
    
    echo -e "\n${YELLOW}🎨 Design Guidelines from $AUGMENT_FILE:${NC}"
    grep -A 15 "## 🎨 Design Guidelines" "$AUGMENT_FILE" | head -15
}

validate_alignment() {
    echo -e "${BLUE}🔍 Validating BMAD + Augment Alignment${NC}"
    echo "======================================"
    
    local issues=0
    
    # Check if both files exist
    if [ ! -f "$BMAD_FILE" ]; then
        echo -e "${RED}❌ $BMAD_FILE not found${NC}"
        ((issues++))
    fi
    
    if [ ! -f "$AUGMENT_FILE" ]; then
        echo -e "${RED}❌ $AUGMENT_FILE not found${NC}"
        ((issues++))
    fi
    
    # Check for placeholder content
    if grep -q "\[Your Project Name\]" "$AUGMENT_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Placeholder content found in $AUGMENT_FILE${NC}"
        ((issues++))
    fi
    
    if grep -q "\[What unique value\]" "$BMAD_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Placeholder content found in $BMAD_FILE${NC}"
        ((issues++))
    fi
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ All validations passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Found $issues issues to address${NC}"
    fi
}

generate_prompt() {
    local task="$1"
    if [ -z "$task" ]; then
        echo -e "${RED}❌ Task name required${NC}"
        exit 1
    fi
    
    echo -e "${CYAN}🤖 Generated Augment Code Prompt for: $task${NC}"
    echo "=================================================="
    echo ""
    echo "Following the BMAD framework in $BMAD_FILE and the technical"
    echo "specifications in $AUGMENT_FILE, implement the $task."
    echo ""
    echo "Please:"
    echo "1. Consider the business context and success metrics from BMAD"
    echo "2. Follow the coding standards and design guidelines from augment-instructions"
    echo "3. Ensure the implementation addresses all four BMAD layers:"
    echo "   - Business requirements and user value"
    echo "   - Data model and business rules"
    echo "   - Architecture patterns and integration"
    echo "   - User experience and visual design"
    echo "4. Update the progress tracking when completed"
    echo ""
    echo "Focus on creating a solution that is both technically excellent"
    echo "and aligned with business objectives."
    echo ""
    echo -e "${BLUE}📋 Copy the above prompt to use with Augment Code${NC}"
}

# Main script logic
case "$1" in
    "init")
        init_workflow
        ;;
    "create-task")
        create_task "$2"
        ;;
    "business")
        show_business_context "$2"
        ;;
    "model")
        show_data_model "$2"
        ;;
    "architecture")
        show_architecture "$2"
        ;;
    "design")
        show_design "$2"
        ;;
    "validate")
        validate_alignment
        ;;
    "generate-prompt")
        generate_prompt "$2"
        ;;
    "help"|"-h"|"--help"|"")
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        show_help
        exit 1
        ;;
esac
