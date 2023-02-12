#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

typedef struct ht_item
{
    char *key;
    char *value;
} ht_item;

typedef struct ht_hash_table
{
    int size;   // total size of ht
    int count;  // no. of items currently in ht
    ht_item **items;
} ht_hash_table;

static ht_item* ht_new_item(const char *k, const char *v) {
    ht_item *i = malloc(sizeof(ht_item));
    i->key = strdup(k);
    i->value = strdup(v);
    return i;
}

static ht_hash_table* ht_new() {
    ht_hash_table* ht = malloc(sizeof(ht_hash_table));

    ht->size = 53;
    ht->count = 0;
    ht->items = calloc((size_t)ht->size, sizeof(ht_item*));
    return ht;
}

static void ht_del_item(ht_item *i) {
    free(i->key);
    free(i->value);
    free(i);
}

void ht_del_hash_table(ht_hash_table* ht) {
    for (int i = 0; i < ht->size; i++)
    {
        ht_item* item = ht->items[i];
        if(item != NULL) {
            ht_del_item(item);
        }
    }
    free(ht->items);
    free(ht);
}

static int ht_hash(const char* s, const int a, const int m) {
    long hash = 0;
    const int len_s = strlen(s);
    for (int i = 0; i < len_s; i++) {
        hash += (long)pow(a, len_s - (i+1)) * s[i];
        hash = hash % m;
    }
    return (int)hash;
}

static int ht_get_hash(
    const char* s, const int num_buckets, const int attempt
) {
    const int hash_a = ht_hash(s, 151, num_buckets);
    const int hash_b = ht_hash(s, 191, num_buckets);
    return (hash_a + (attempt * (hash_b + 1))) % num_buckets;
}

void ht_insert(ht_hash_table* ht, const char* key, const char* value) {
    ht_item* item = ht_new_item(key, value);
    int index = ht_get_hash(item->key, ht->size, 0);
    ht_item* cur_item = ht->items[index];
    int i = 1;
    while (cur_item != NULL) {  
        // if an item already exists within the hash
        index = ht_get_hash(item->key, ht->size, i);
        cur_item = ht->items[index];
        i++;
    } 
    ht->items[index] = item;
    ht->count++;
}

char* ht_search(ht_hash_table* ht, const char* key) {
    int index = ht_get_hash(key, ht->size, 0);
    ht_item* item = ht->items[index];
    int i = 1;
    while (item != NULL) {
        if (strcmp(item->key, key) == 0) {
            return item->value;
        }
        index = ht_get_hash(key, ht->size, i);
        item = ht->items[index];
        i++;
    } 
    return NULL;
}

void ht_print_hashtable(ht_hash_table* ht, FILE *fp) {
    for(int i = 0; i < ht->size; i++) {
        if(ht->items[i]) {
            fprintf(fp, "{%s\t->\t%s}\n", ht->items[i]->key, ht->items[i]->value);
        }
    }
}

/*
void main() {
    ht_hash_table* ht = ht_new();
    ht_insert(ht, "a", "id");
    ht_insert(ht, "b", "keyword");
    ht_print_hashtable(ht);
    ht_del_hash_table(ht);
}
*/


