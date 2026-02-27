# Code Generation Workflow (New Code)

> **Rules**
> - Follow steps **IN ORDER** — do not skip steps
> - Load rules **per class**, not all at once — avoid context overload
> - Make as many MCP requests as needed — each call must have a clear purpose; never skip a call that improves code quality
> - Each step is a **checkpoint** — use your own best practices to get there; sub-steps are goals, not a rigid procedure

## Step 1: Planning & Architecture

**Actions**:
1. Load architecture rules from MCP.
2. Plan the implementation:
   - Identify required classes (DTOs, Services, Responses, Resolvers, etc.)
   - Determine correct package for each class
   - Load naming conventions for each class type
   - Define class names following naming conventions
   - Plan dependencies between classes
3. Document the plan:
   - List all classes to create
   - Specify package for each class
   - Note which rules apply to each class type
4. Create packages and classes:
   - Create packages according to rules and notes
   - Create classes according to rules and notes

## Step 2: Class Implementation

**Purpose**: For each class, load specific rules, then create the complete class with all internals.

**Actions**: Create classes **ONE BY ONE** — for each class:
1. Load rules for **this specific** class type from MCP:
   - Use class type from the plan to determine which rules to load
   - Review all loaded rules before writing any code
2. Implement class internals:
   - Declare class with correct signature
   - Declare fields
   - Implement methods
   - Apply annotations per loaded rules
3. Add imports based on implemented code, following the loaded rules
4. Verify this class is complete:
   - Class in correct package with correct name and suffix
   - Field and method names follow naming conventions per loaded rules
   - Imports organized correctly per loaded rules
   - All class internals comply with loaded rules
5. Move to **next class** and **repeat from step 1** until all classes are created

## Step 3: Test Implementation

**Purpose**: For each implemented class, load test rules and create corresponding test class.

**Actions**: Create test classes **ONE BY ONE** — for each class:
1. Load rules for **this specific** test class type from MCP:
   - Use class type from the plan to determine which rules to load
   - Review all loaded rules before writing any code
2. Implement test class internals:
   - Declare class with correct signature
   - Declare fields
   - Implement test methods
   - Apply annotations per loaded rules
3. Add imports based on implemented code, following the loaded rules
4. Verify this test class is complete:
   - Class in correct package with correct name and suffix
   - Field and method names follow naming conventions per loaded rules
   - Imports organized correctly per loaded rules
   - All class internals comply with loaded rules
5. Move to **next class** and **repeat from step 1** until all classes are covered

## Step 4: Compile & Verify

**Purpose**: Ensure code compiles and all tests pass.

**Actions**:
1. Detect build tool (Maven or Gradle) and compile the project
2. Fix any compilation errors and **repeat from step 1** until compilation succeeds
3. Run tests using detected build tool
4. If tests fail:
   - Fix implementation — go back to **Step 2**
   - Fix tests — go back to **Step 3**
   - Re-run until all tests pass
5. Verify:
   - All tests pass
   - No existing tests broken