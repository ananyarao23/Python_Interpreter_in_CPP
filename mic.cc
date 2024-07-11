#include <mic.hh>

std::map<std::string, double> table;

vector<stat*> *append_stmt(vector<stat*> *list, stat* stmt){
    if(list==nullptr) list = new vector<stat*>();
    list->push_back(stmt);
    return list;
}

vector<expression*> *append_exp(vector<expression*> *list, expression* exp){
    if(list==nullptr) list = new vector<expression*>();
    list->push_back(exp);
    return list;
}

vector<string> *append_args(vector<string> *args_list, string arg){
    if(args_list == nullptr) args_list = new vector<string>();
    args_list->push_back(arg);
    return args_list;
}