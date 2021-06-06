// RUN: %cheri_cc1 %s -fsyntax-only -Wall -Wno-unused-variable -std=c++11 -verify


struct ref_struct {
    int& ref;
};

struct cap_struct {
    int& __capability ref;
};

void test_assignment(int& ptrref, int& __capability capref) {
  int i;

  int &ptr1 = ptrref; // okay
  int &ptr2 = capref; // expected-error {{converting capability type 'int & __capability' to non-capability type 'int &' without an explicit cast}}

  int &__capability
  cap1 = capref; // okay
  int &__capability
  cap2 = ptrref; // expected-error {{converting non-capability type 'int &' to capability type 'int & __capability' without an explicit cast}}

  // can only bind a non-capability ref to i:
  int &ptrref2 = i;
  int &__capability capref2 = i; //expected-error{{converting non-capability type 'int &' to capability type 'int & __capability' without an explicit cast}}

  // check intializer lists:
  ref_struct sp1 = {ptrref};
  ref_struct sp2 = {capref}; // expected-error {{converting capability type 'int & __capability' to non-capability type 'int &' without an explicit cast}}
  ref_struct sp3 = {i};

  cap_struct sc1 = {ptrref}; // expected-error{{converting non-capability type 'int &' to capability type 'int & __capability' without an explicit cast}}
  cap_struct sc2 = {capref};
  cap_struct sc3 = {i}; // expected-error{{converting non-capability type 'int &' to capability type 'int & __capability' without an explicit cast}}
}

void init(int& ptrref, int& __capability capref) {
  using PtrRef = int &;
  using CapRef = int & __capability;
  int i = 0;

  // function cast/ctor:
  PtrRef pc1(ptrref);
  PtrRef pc2(capref); // expected-error{{converting capability type 'int & __capability' to non-capability type 'PtrRef' (aka 'int &') without an explicit cast}}
  PtrRef pc3(i);
  CapRef cc1(ptrref); // expected-error{{converting non-capability type 'int &' to capability type 'CapRef' (aka 'int & __capability') without an explicit cast}}
  CapRef cc2(capref);
  CapRef cc3(i); // expected-error{{converting non-capability type 'int &' to capability type 'CapRef' (aka 'int & __capability') without an explicit cast}}
  // brace init:
  PtrRef pi1{ptrref};
  PtrRef pi2{capref}; // expected-error{{converting capability type 'int & __capability' to non-capability type 'PtrRef' (aka 'int &') without an explicit cast}}
  PtrRef pi3{i};
  CapRef ci1{ptrref}; // expected-error{{converting non-capability type 'int &' to capability type 'CapRef' (aka 'int & __capability') without an explicit cast}}
  CapRef ci2{capref};
  CapRef ci3{i}; // expected-error{{converting non-capability type 'int &' to capability type 'CapRef' (aka 'int & __capability') without an explicit cast}}
  // assign init list:
  PtrRef pai1 = {ptrref};
  PtrRef pai2 = {capref}; // expected-error{{converting capability type 'int & __capability' to non-capability type 'PtrRef' (aka 'int &') without an explicit cast}}
  PtrRef pai3 = {i};
  CapRef cai1 = {ptrref}; // expected-error{{converting non-capability type 'int &' to capability type 'CapRef' (aka 'int & __capability') without an explicit cast}}
  CapRef cai2 = {capref};
  CapRef cai3 = {i}; // expected-error{{converting non-capability type 'int &' to capability type 'CapRef' (aka 'int & __capability') without an explicit cast}}
  int Foo = capref;  // ok
}

struct foo2 {
    int& __capability cap;
    int& ptr;
};

void test_two_member_struct(int& __capability a) {
  foo2 f{a, a}; // expected-error {{converting capability type 'int & __capability' to non-capability type 'int &' without an explicit cast}}
  foo2 f2 = {a, a}; // expected-error {{converting capability type 'int & __capability' to non-capability type 'int &' without an explicit cast}}
}

struct struct_with_ctor_ref {
    struct_with_ctor_ref(int &);
};

struct struct_with_ctor_cap {
    struct_with_ctor_cap(int& __capability);
};

void test_struct_with_ctor(int& ptrref, int& __capability capref, int i) {
  struct_with_ctor_ref r1 = ptrref;
  struct_with_ctor_ref r2 = capref; // expected-error {{no viable conversion from 'int' to 'struct_with_ctor_ref'}}
  // expected-note@-11 {{candidate constructor (the implicit copy constructor) not viable: no known conversion from 'int' to 'const struct_with_ctor_ref &' for 1st argument}}
  // expected-note@-12 {{candidate constructor (the implicit move constructor) not viable: no known conversion from 'int' to 'struct_with_ctor_ref &&' for 1st argument}}
  // expected-note@-12 {{candidate constructor not viable: no known conversion from 'int' to 'int &' for 1st argument}}
  struct_with_ctor_ref r3 = i;

  struct_with_ctor_cap c1 = ptrref; // expected-error{{no viable conversion from 'int' to 'struct_with_ctor_cap'}}
  // expected-note@-13 {{candidate constructor (the implicit move constructor) not viable: no known conversion from 'int' to 'struct_with_ctor_cap &&' for 1st argument}}
  // expected-note@-14 {{candidate constructor (the implicit copy constructor) not viable: no known conversion from 'int' to 'const struct_with_ctor_cap &' for 1st argument}}
  // expected-note@-14 {{candidate constructor not viable: no known conversion from 'int' to 'int & __capability' for 1st argument}}
  struct_with_ctor_cap c2 = capref;
  struct_with_ctor_cap c3 = i; // expected-error{{no viable conversion from 'int' to 'struct_with_ctor_cap'}}
  // expected-note@-18 {{candidate constructor (the implicit copy constructor) not viable: no known conversion from 'int' to 'const struct_with_ctor_cap &' for 1st argument}}
  // expected-note@-19 {{candidate constructor (the implicit move constructor) not viable: no known conversion from 'int' to 'struct_with_ctor_cap &&' for 1st argument}}
  // expected-note@-19 {{candidate constructor not viable: no known conversion from 'int' to 'int & __capability' for 1st argument}}
}

__intcap get_intcap();


void test_intcap(__intcap& lval, __intcap&& rval) {
  __intcap& ref1 = get_intcap(); // expected-error {{non-const lvalue reference to type '__intcap' cannot bind to a temporary of type '__intcap'}}
  const __intcap& ref2 = get_intcap();
  __intcap&& ref3 = get_intcap();

  unsigned __intcap intcap1 = lval;
  unsigned __intcap intcap2 = rval;
}

struct Foo {
  int a;
  Foo(const struct Foo & __capability a) {
    this->a = a.a;
  };
  Foo(const struct Foo &a) {
    this->a = a.a;
  };
};

struct Foo fooCapConstructor(struct Foo * __capability c_foo) {
  struct Foo a = *c_foo;
  return a;
}

int fooCapConstructor1(struct Foo *__capability a) {
  struct Foo b = fooCapConstructor(a);
  return b.a;
}
void fooCapConstructor2(struct Foo * __capability c_foo, struct Foo foo) {
  *c_foo = foo;
}

int capArgFun(char *__capability &in);

int capArgTest1(char *__capability c) {
  return capArgFun(c);
}

int capArgFun1(char * &__capability in);

int capArgTest2(char *c) {
  return capArgFun1(c);  // expected-error {{converting non-capability reference to type 'char *' to capability type 'char *& __capability' without an explicit cast; if this is intended use __cheri_tocap}}
  // expected-note@-4 {{passing argument to parameter 'in' here}}
}
