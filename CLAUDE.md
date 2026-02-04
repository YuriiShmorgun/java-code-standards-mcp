# Java Code Standards

## Formatting

### Line Length
- Maximum line length: **150 characters**
- If a line exceeds 150 characters, break it according to these priorities:
  1. After opening parenthesis of method call
  2. Before `.` in method chains
  3. After `,` in parameter/argument lists
  4. Before binary operators (`&&`, `||`, `+`)

```java
// WRONG — exceeds 150 characters
public ResponseEntity<UserDTO> updateUserProfile(Long userId, String firstName, String lastName, String email, String phone, LocalDate birthDate) {

// CORRECT — broken after opening parenthesis
public ResponseEntity<UserDTO> updateUserProfile(
        Long userId, String firstName, String lastName,
        String email, String phone, LocalDate birthDate) {

// WRONG — method chain exceeds 150 characters
List<UserDTO> result = userRepository.findByActiveAndDepartment(true, department).stream().filter(u -> u.getAge() > 18).map(UserMapper::toDTO).collect(Collectors.toList());

// CORRECT — broken before each `.`
List<UserDTO> result = userRepository
        .findByActiveAndDepartment(true, department)
        .stream()
        .filter(u -> u.getAge() > 18)
        .map(UserMapper::toDTO)
        .collect(Collectors.toList());
```

---

## Imports

### No Static Imports
- `import static` is **forbidden** in all cases
- Always use the fully qualified class reference instead

```java
// WRONG
import static java.lang.Math.PI;
import static java.lang.Math.sqrt;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

// CORRECT
import java.lang.Math;
import org.junit.jupiter.api.Assertions;
import org.mockito.Mockito;

// Usage in code:
double area = Math.PI * Math.sqrt(radius);
Assertions.assertEquals(expected, actual);
Mockito.when(mock.method()).thenReturn(value);
```

### No Wildcard Imports
- `import package.*` is **forbidden**
- Every imported class must be listed explicitly

```java
// WRONG
import java.util.*;
import com.example.service.*;
import org.springframework.web.bind.annotation.*;

// CORRECT
import java.util.List;
import java.util.Map;
import java.util.Optional;
import com.example.service.UserService;
import com.example.service.OrderService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
```

### Import Order
Imports must be grouped in this order, with a blank line between each group:
1. `java.*` and `javax.*`
2. Third-party libraries (e.g. `org.springframework`, `com.google`, `io.*)
3. Project packages (e.g. `com.yourcompany.*`)

```java
// CORRECT order
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;

import com.yourcompany.domain.model.User;
import com.yourcompany.service.UserService;
```
## Lookup Logic

### No Switch-Based Lookup Tables
- Using `switch` (or long `if-else` chains) as lookup tables is **forbidden**
- Lookup logic must not be implemented as control flow
- Constant mappings must be expressed as data structures

```java
// WRONG
default String getCountryName(Integer siteCode) {
    if (siteCode == null) return null;
    return switch (siteCode) {
        case 0 -> "USA";
        case 3 -> "UK";
        case 15 -> "Australia";
        case 71 -> "France";
        case 77 -> "Germany";
        default -> "Site " + siteCode;
    };
}

// CORRECT
private static final Map<Integer, String> SITE_COUNTRIES = Map.of(
    0, "USA",
    3, "UK",
    15, "Australia",
    71, "France",
    77, "Germany"
);

default String getCountryName(Integer siteCode) {
    if (siteCode == null) return null;
    return SITE_COUNTRIES.getOrDefault(siteCode, "Site " + siteCode);
}
```

## Variables

### No `var` Declarations
- Usage of `var` for local variable declarations is **forbidden**
- All variables must use explicit, concrete types
- Type inference must not be relied upon for readability

```java
// WRONG
var count = 10;
var user = userService.findById(id);
var result = calculateResult();
var map = new HashMap<String, List<User>>();

// CORRECT
int count = 10;
User user = userService.findById(id);
Result result = calculateResult();
Map<String, List<User>> map = new HashMap<>();
```

### Variable Naming Convention

- Variables must use lowerCamelCase
- No underscores, prefixes, or Hungarian notation
- Abbreviations must be treated as words

```java
// WRONG
int item_count;
String userID;
HttpRequest HTTPRequest;

// CORRECT
int itemCount;
String userId;
HttpRequest httpRequest;
```

### Semantic Variable Naming

- Variable names must clearly describe what the object represents
- Generic or meaningless names are forbidden

```java
// WRONG
String data;
String value;
Object obj;
List<User> list;
Map<String, String> map;

// CORRECT
String countryCode;
String orderStatus;
List<User> activeUsers;
Map<String, String> countryByCode;
```

### No Meaningless Names

The following names are forbidden unless the scope is trivial:
- data
- info
- value
- object
- result
- temp, tmp
- item, element
- list, map, set

### Collection Variable Naming Rules

- Collections must use plural names
- Maps must describe key → value relationship

```java
// WRONG
List<User> user;
Map<String, Order> orders;

// CORRECT
List<User> users;
Map<String, Order> orderById;
```

### Boolean Naming

Boolean variables must start with is, has, or can

```java
// WRONG
boolean active;
boolean permission;
boolean retry;

// CORRECT
boolean isActive;
boolean hasPermission;
boolean canRetry;
```

## Time and Date Handling

### No String or Numeric Timestamps
- Time and date values must **not** be represented as `String`, `Long`, `Integer`, or any numeric type
- Timestamps must **never** be exposed as raw epoch values or formatted strings in domain or API models
- All time-related fields must use `LocalDateTime`

```java
// WRONG
public static class ExecuteDispositionPackageResponse {
    private String timestamp;
}

public static class ExecuteDispositionPackageResponse {
    private Long timestamp;
}

// CORRECT
public static class ExecuteDispositionPackageResponse {
    private LocalDateTime timestamp;
}
```

### External Input Conversion Rule

When receiving time values from external systems (APIs, DBs, messages):
- String, Long, Integer, or other formats are allowed only at the boundary
- They must be converted immediately to LocalDateTime
- Raw external representations must not propagate into business logic

```java
// ALLOWED (boundary only)
String externalTimestamp = response.getTimestamp();

// CORRECT
LocalDateTime timestamp = LocalDateTime.parse(externalTimestamp);

// ALLOWED (epoch-based input)
long epochMillis = externalResponse.getTimestamp();

LocalDateTime timestamp =
Instant.ofEpochMilli(epochMillis)
.atZone(ZoneId.systemDefault())
.toLocalDateTime();
```

### Forbidden Propagation

Raw timestamps must not be:
- Stored in domain objects
- Passed between services
- Used in business logic
- Exposed in public APIs

```java
// WRONG
process(timestampString);
save(timestampLong);

// CORRECT
process(timestamp);
save(timestamp);
```

## DTO (Data Transfer Objects) Guidelines

### DTO Rules

- DTOs must be implemented as **regular classes**
- Java `record` is **forbidden** for DTOs
- DTOs may be used as transfer objects:
  - between methods
  - between packages
  - between layers
  - between services
- DTOs are **data carriers**, not domain models

---

### Package and Naming

- DTOs must be located in a package named `model`
- DTO class names must end with `Dto`

```text
com.yourcompany.feature.model
 └── UserDto
```

### Structure and Immutability

- DTOs must be immutable by convention
- DTOs must not contain business logic
- DTOs must not contain validation logic
- DTOs must not extend other classes
- DTOs must not contain behavior
- DTOs must not use record
- DTOs must use Lombok
- Object creation must be done via @Builder
- Constructors must be private

### DTOs used for JSON serialization/deserialization must:
- Ignore unknown JSON properties
- Use builder-based Jackson deserialization
- Explicitly define JSON field names

### The following are forbidden:
- record DTOs
- Public constructors
- Public fields
- Mutable DTOs
- Business or validation logic
- Partial Lombok usage without @Builder

```java
// WRONG
public record AccountDetails(
    String id;
    String name;
) {
}

// CORRECT
@Value
@Builder
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class AccountDetailsDto {

    @NonNull
    private String id;

    private String name;
}

// CORRECT
@Value
@Builder
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonDeserialize(builder = UserDto.UserDtoBuilder.class)
public class UserDto {

  @NonNull
  @JsonProperty("id")
  private String id;

  @JsonProperty("name")
  private String name;

  @Builder.Default
  private Instant createdAt = Instant.now();
}
```

