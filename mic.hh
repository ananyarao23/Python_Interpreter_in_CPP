// #include <bits/stdc++.h>
// using namespace std;

// // Forward declarations
// class Expression;
// class Statement;
// class Object;

// // Using smart pointers for memory management
// using ExprPtr = Expression*;
// using StmtPtr = Statement*;
// using ObjPtr = Object*;

// // Enum class for object types
// enum class ObjType {
//     INT,
//     FLOAT,
//     STRING,
//     BOOL,
//     NULLTYPE
// };

// // Enum class for expression types
// enum class ExprType {
//     LITERAL,
//     VARIABLE,
//     BINARY,
//     UNARY,
//     FUNCTION,
//     FUNCCALL
// };

// // Base class for all objects
// class Object {
// public:
//     ObjType type;
//     virtual ~Object() = default;
// };

// // Derived class for literal objects
// class LiteralObject : public Object {
// public:
//     union {
//         int intValue;
//         double floatValue;
//         std::string* stringValue;
//         bool boolValue;
//     } value;

//     LiteralObject(int v) {
//         type = ObjType::INT;
//         value.intValue = v;
//     }

//     LiteralObject(double v) {
//         type = ObjType::FLOAT;
//         value.floatValue = v;
//     }

//     LiteralObject(const std::string& v) {
//         type = ObjType::STRING;
//         value.stringValue = new std::string(v);
//     }

//     LiteralObject(bool v) {
//         type = ObjType::BOOL;
//         value.boolValue = v;
//     }

//     ~LiteralObject() {
//         if (type == ObjType::STRING) {
//             delete value.stringValue;
//         }
//     }
// };

// // Base class for all expressions
// class Expression {
// public:
//     ExprType type;
//     virtual ~Expression() = default;
// };

// // Derived class for literal expressions
// class LiteralExpression : public Expression {
// public:
//     ObjPtr literal;
//     LiteralExpression(ObjPtr lit) : literal(lit) { type = ExprType::LITERAL; }
// };

// // Derived class for variable expressions
// class VariableExpression : public Expression {
// public:
//     std::string name;
//     VariableExpression(const std::string& name) : name(name) { type = ExprType::VARIABLE; }
// };

// // Derived class for binary expressions
// class BinaryExpression : public Expression {
// public:
//     enum Op { ADD, SUBTRACT, MULTIPLY, DIVIDE, MOD, EQ, NE, LT, LE, GT, GE, AND, OR } op;
//     ExprPtr left;
//     ExprPtr right;
//     BinaryExpression(Op op, ExprPtr left, ExprPtr right) : op(op), left(left), right(right) { type = ExprType::BINARY; }
// };

// // Derived class for unary expressions
// class UnaryExpression : public Expression {
// public:
//     enum Op { NEGATE, NOT } op;
//     ExprPtr operand;
//     UnaryExpression(Op op, ExprPtr operand) : op(op), operand(operand) { type = ExprType::UNARY; }
// };

// // Class for function definitions
// class Function : public Expression {
// public:
//     std::vector<std::string> args;
//     std::vector<StmtPtr> body;
//     Function(const std::vector<std::string>& args, const std::vector<StmtPtr>& body) : args(args), body(body) { type = ExprType::FUNCTION; }
// };

// // Class for function calls
// class FuncCall : public Expression {
// public:
//     std::string funcName;
//     std::vector<ExprPtr> args;
//     FuncCall(const std::string& funcName, const std::vector<ExprPtr>& args) : funcName(funcName), args(args) { type = ExprType::FUNCCALL; }
// };

// // Base class for all statements
// class Statement {
// public:
//     virtual ~Statement() = default;
// };

// // Derived class for let statements
// class LetStatement : public Statement {
// public:
//     std::string name;
//     ExprPtr value;
//     LetStatement(const std::string& name, ExprPtr value) : name(name), value(value) {}
// };

// // Derived class for assignment statements
// class AssignmentStatement : public Statement {
// public:
//     std::string name;
//     ExprPtr value;
//     AssignmentStatement(const std::string& name, ExprPtr value) : name(name), value(value) {}
// };

// // Derived class for return statements
// class ReturnStatement : public Statement {
// public:
//     ExprPtr value;
//     ReturnStatement(ExprPtr value) : value(value) {}
// };

// // Derived class for if statements
// class IfStatement : public Statement {
// public:
//     ExprPtr condition;
//     StmtPtr thenBranch;
//     StmtPtr elseBranch;
//     IfStatement(ExprPtr condition, StmtPtr thenBranch, StmtPtr elseBranch = nullptr)
//         : condition(condition), thenBranch(thenBranch), elseBranch(elseBranch) {}
// };

// // Derived class for expression statements
// class ExpressionStatement : public Statement {
// public:
//     ExprPtr expression;
//     ExpressionStatement(ExprPtr expression) : expression(expression) {}
// };
// using FuncPtr = Function*;
// using FuncCallPtr = FuncCall*;


#include <bits/stdc++.h>
using namespace std;

enum const_type{
    NUMBER,
    BOOL,
    STRING,

};

struct var_as_op;
struct const_as_op;
struct arr_list;
struct arr;
struct dict_item;
struct dict_list;
struct dict;
struct expression;
struct if_cond;
struct if_stat;
struct assignment_stat;
struct param;
struct arg;
struct args;
struct func_stmt;
struct func_def;
struct func_call;
struct stat;
struct stat_list;
struct program;

// Symbol table to store variable values
map<string, const_as_op*> symbol_table;

struct program {
    stat_list* statements;

    program(stat_list* sl) : statements(sl) {}
};

// I am not sure what we are doing 
// same but i will like to believe it's not complete nonsense 
// kal abhijit ko dikhane aur puchne ke liye kuch to rhega apne paas
// and btw this struct looks fine, for now

struct stat_list {
    vector<stat*> statements;
    stat_list() {}
    void add_stat(stat* s) {
        statements.push_back(s);
    }
};

struct compound_statement {
    stat_list* statements;

    compound_statement(stat_list* sl) : statements(sl) {}
};

struct stat {
    enum { ASSIGN, IF, COMPOUND, FUNC_DEF, FUNC_CALL } stat_type;
    union {
        assignment_stat* assign_stat;
        if_stat* if_statement;
        struct compound_statement* compound_stmt;
        func_def* func_definition;
        func_call* function_call;
    };

    stat(assignment_stat* a) : stat_type(ASSIGN), assign_stat(a) {}
    stat(if_stat* i) : stat_type(IF), if_statement(i) {}
    stat(compound_statement* c) : stat_type(COMPOUND), compound_stmt(c) {}
    stat(func_def* f) : stat_type(FUNC_DEF), func_definition(f) {}
    stat(func_call* fc) : stat_type(FUNC_CALL), function_call(fc) {}
};

struct const_as_op{
    enum {NUMBER,BOOL,STRING} ctype;
    void* val; // type not known yet so it can be typecasted later

    const_as_op(string s){
        ctype = STRING;
        val = new string(s);
    }
    const_as_op(const char* s){
        ctype = STRING;
        val = new string(s);
    }
    const_as_op(int x){
        ctype = NUMBER;
        val = new int(x);
    }
    const_as_op(double x){
        ctype = NUMBER;
        val = new double(x);
    }
    const_as_op(bool x){
        ctype = BOOL;
        val = new bool(x);
    }
};

struct var_as_op {
    string name;

    var_as_op(string n) : name(n) {}
};

struct dict{
    map<string,const_as_op*> pairs;
    dict() {}
    ~dict() {}
};
dict* creat_dict(map<string,const_as_op*> *pairs);
map<string,const_as_op*> *append_pair(map<string,const_as_op*> *pairs,pair<string,const_as_op*> *p);


struct arr{
    vector<item*> items;
    arr() {}
    ~arr() {}
};

arr* create_arr(vector<item*> *items);
vector<item*> *append_item(vector<item*> *myarry,item* it);


struct item{
    enum {CONST_AS_OP,ARRAY,DICT} item_type;
    void* val;
    item(arr* myarray): item_type(ARRAY), val(new arr*(myarray)) {}
    item(dict* mydict): item_type(DICT), val(new dict*(mydict)) {}
    item(const_as_op* myop): item_type(CONST_AS_OP), val(new const_as_op*(myop)) {}
};

struct if_cond{
    expression* cond;
    if_cond(){}
};
if_cond* create_if_cond(expression* cond);


void assign(var_as_op* var_name,const_as_op* val);

struct expression {
    enum {EXPRESSION ,CONST, VAR, BIN_OP, UNARY_OP, FUNC_CALL } expr_type;
    union {
        expression* exp;
        const_as_op* constant;
        var_as_op* variable;
        rel_expression* bin_op;
        prefix* uni_op;
        struct func_call* func;
    };
    expression(expression* expr) : exp(expr), expr_type(EXPRESSION) {}
    expression(const_as_op* c) : expr_type(CONST), constant(c) {}
    expression(var_as_op* v) : expr_type(VAR), variable(v) {}
    expression(rel_expression* rel) : expr_type(BIN_OP) {
        bin_op = rel;
    }
    expression(prefix* op) : expr_type(UNARY_OP) {
        uni_op = op;
    }
    expression(func_call* f) : expr_type(FUNC_CALL), func(f) {}

    double evaluate() {
        if(expr_type == EXPRESSION) return exp->evaluate();
        if(expr_type == CONST) return constant->val;
        if(expr_type == BIN_OP) return bin_op->evaluate();
        if(expr_type == VAR) return symbol_table[*variable]->val;
        if(expr_type == UNARY_OP) return uni_op->evaluate();
    }
};

struct rel_expression : public expression {
    expression* left_expr;
    expression* right_expr;
    std::string rel_;
    rel_expression(expression* le, const std::string& r, expression* re)
        : left_expr(le), right_expr(re), rel_(r) {}
    ~rel_expression() {
        delete left_expr;const override
        delete right_expr;
    }
    double evaluate() const override {
        double left_val = left_expr->evaluate();
        double right_val = right_expr->evaluate();
        if (rel_ == "+") return left_val + right_val;
        if (rel_ == "-") return left_val - right_val;
        if (rel_ == "*") return left_val * right_val;
        if (rel_ == "/") return left_val / right_val;
        if (rel_ == "%") return static_cast<int>(left_val) % static_cast<int>(right_val);
        if (rel_ == "==") return left_val == right_val;
        if (rel_ == "!=") return left_val != right_val;
        if (rel_ == "<") return left_val < right_val;
        if (rel_ == "<=") return left_val <= right_val;
        if (rel_ == ">") return left_val > right_val;
        if (rel_ == ">=") return left_val >= right_val;
        if (rel_ == "&") return left_val & right_val;
        if (rel_ == "|") return left_val | right_val;
        throw std::runtime_error("Unknown operator: " + rel_);
    }
};

vector<stat*> *append_stmt(vector<stat*> *list, stat* stmt);
vector<expression*> *append_exp(vector<expression*> *list, expression* exp);
vector<string> *append_args(vector<string> *args_list, string arg);