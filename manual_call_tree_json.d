#pragma D option quiet


self int order, level;


#define CLASSES_PROBE(name)         \
//objc$target:SomeClass*::name,       \
//objc$target:OtherClass*::name,      \
objc$target:Ti*::name


CLASSES_PROBE(entry),
CLASSES_PROBE(return)
{
    printf("{\n\t\"probemod\": \"%s\",\n\t\"probefunc\": \"%s\",\n\t\"direction\": \"%s\",\n\t\"pid\": %lld,\n\t\"order\": %d", probemod, probefunc, probename, (long long)tid, ++self->order);
}


CLASSES_PROBE(entry)
{
    printf(",\n\t\"level\": %d,\n\t\"stack\": \"", self->level++);
    ustack(20);
    printf("\"},\n")
}


CLASSES_PROBE(return)
{
    printf(",\n\t\"level\": %d\n},\n", --self->level);
}
