#include <bits/stdc++.h>
using namespace std;

enum const_type{
    NUMBER,
    BOOL,
    STRING,

};

struct var_as_op;
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

struct Value {
    const_type type;
    void* value;

    Value(const_type t, void* v) : type(t), value(v) {}
};

// Symbol table to store variable values
map<string, Value*> symbol_table;

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

struct rel_expression{
    expression* left_expr,*right_expr;
    string rel_;
    rel_expression(expression* le,string r,expression* re): left_expr(le),right_expr(re),rel_(r) {}
};

struct if_cond{
    expression* cond;
    if_cond(){}
};
if_cond* create_if_cond(expression* cond);


void assign(var_as_op* var_name,const_as_op* val);

struct expression {
    enum { CONST, VAR, BIN_OP, UNARY_OP, FUNC_CALL } expr_type;
    union {
        const_as_op* constant;
        var_as_op* variable;
        struct {
            expression* left;
            string op;
            expression* right;
        } bin_op;
        struct {
            string op;
            expression* operand;
        } unary_op;
        struct func_call* func;
    };

    expression(const_as_op* c) : expr_type(CONST), constant(c) {}
    expression(var_as_op* v) : expr_type(VAR), variable(v) {}
    expression(expression* l, string o, expression* r) : expr_type(BIN_OP) {
        bin_op.left = l;
        bin_op.op = o;
        bin_op.right = r;
    }
    expression(string o, expression* opnd) : expr_type(UNARY_OP) {
        unary_op.op = o;
        unary_op.operand = opnd;
    }
    expression(func_call* f) : expr_type(FUNC_CALL), func(f) {}
};


