func id<A>(a: A) -> A {
    return a
}

func compose<A, B, C>(fa: A -> B, _ fb: B -> C) -> A -> C {
    return { x in fb(fa(x)) }
}

func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
    return { a in { b in f(a, b) }}
}
