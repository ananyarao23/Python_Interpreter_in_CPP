#include <bits/stdc++.h>
using namespace std;

// Forward declarations
class Expression;
class Statement;
class Object;

// Using smart pointers for memory management
using ExprPtr = std::shared_ptr<Expression>;
using StmtPtr = std::shared_ptr<Statement>;
using ObjPtr = std::shared_ptr<Object>;

// Enum class for object types
enum class ObjType {
    INT,
    FLOAT,
    STRING,
    BOOL,
    NULLTYPE
};

// Enum class for expression types
enum class ExprType {
    LITERAL,
    VARIABLE,
    BINARY,
    UNARY,
    FUNCTION,
    FUNCCALL
};

// Base class for all objects
class Object {
public:
    ObjType type;
    virtual ~Object() = default;
};

// Derived class for literal objects
class LiteralObject : public Object {
public:
    union {
        int intValue;
        double floatValue;
        std::string* stringValue;
        bool boolValue;
    } value;

    LiteralObject(int v) {
        type = ObjType::INT;
        value.intValue = v;
    }

    LiteralObject(double v) {
        type = ObjType::FLOAT;
        value.floatValue = v;
    }

    LiteralObject(const std::string& v) {
        type = ObjType::STRING;
        value.stringValue = new std::string(v);
    }

    LiteralObject(bool v) {
        type = ObjType::BOOL;
        value.boolValue = v;
    }

    ~LiteralObject() {
        if (type == ObjType::STRING) {
            delete value.stringValue;
        }
    }
};

// Base class for all expressions
class Expression {
public:
    ExprType type;
    virtual ~Expression() = default;
};

// Derived class for literal expressions
class LiteralExpression : public Expression {
public:
    ObjPtr literal;
    LiteralExpression(ObjPtr lit) : literal(lit) { type = ExprType::LITERAL; }
};

// Derived class for variable expressions
class VariableExpression : public Expression {
public:
    std::string name;
    VariableExpression(const std::string& name) : name(name) { type = ExprType::VARIABLE; }
};

// Derived class for binary expressions
class BinaryExpression : public Expression {
public:
    enum Op { ADD, SUBTRACT, MULTIPLY, DIVIDE, MOD, EQ, NE, LT, LE, GT, GE, AND, OR } op;
    ExprPtr left;
    ExprPtr right;
    BinaryExpression(Op op, ExprPtr left, ExprPtr right) : op(op), left(left), right(right) { type = ExprType::BINARY; }
};

// Derived class for unary expressions
class UnaryExpression : public Expression {
public:
    enum Op { NEGATE, NOT } op;
    ExprPtr operand;
    UnaryExpression(Op op, ExprPtr operand) : op(op), operand(operand) { type = ExprType::UNARY; }
};

// Class for function definitions
class Function : public Expression {
public:
    std::vector<std::string> args;
    std::vector<StmtPtr> body;
    Function(const std::vector<std::string>& args, const std::vector<StmtPtr>& body) : args(args), body(body) { type = ExprType::FUNCTION; }
};

// Class for function calls
class FuncCall : public Expression {
public:
    std::string funcName;
    std::vector<ExprPtr> args;
    FuncCall(const std::string& funcName, const std::vector<ExprPtr>& args) : funcName(funcName), args(args) { type = ExprType::FUNCCALL; }
};

// Base class for all statements
class Statement {
public:
    virtual ~Statement() = default;
};

// Derived class for let statements
class LetStatement : public Statement {
public:
    std::string name;
    ExprPtr value;
    LetStatement(const std::string& name, ExprPtr value) : name(name), value(value) {}
};

// Derived class for assignment statements
class AssignmentStatement : public Statement {
public:
    std::string name;
    ExprPtr value;
    AssignmentStatement(const std::string& name, ExprPtr value) : name(name), value(value) {}
};

// Derived class for return statements
class ReturnStatement : public Statement {
public:
    ExprPtr value;
    ReturnStatement(ExprPtr value) : value(value) {}
};

// Derived class for if statements
class IfStatement : public Statement {
public:
    ExprPtr condition;
    StmtPtr thenBranch;
    StmtPtr elseBranch;
    IfStatement(ExprPtr condition, StmtPtr thenBranch, StmtPtr elseBranch = nullptr)
        : condition(condition), thenBranch(thenBranch), elseBranch(elseBranch) {}
};

// Derived class for expression statements
class ExpressionStatement : public Statement {
public:
    ExprPtr expression;
    ExpressionStatement(ExprPtr expression) : expression(expression) {}
};
using FuncPtr = std::shared_ptr<Function>;
using FuncCallPtr = std::shared_ptr<FuncCall>;
