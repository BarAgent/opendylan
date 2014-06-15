Language differences
====================

.. current-library:: dylan
.. current-module:: dylan

Tables
------

For efficiency, Open Dylan adopts a slightly different table protocol
to that described by the DRM. Hashing functions take an additional
hash-state argument and merge it into the hash-state result. The
function :drm:`merge-hash-codes` is replaced by :func:`merge-hash-ids` because
hash-states are merged as part of the hashing process. The constant
``$permanent-hash-state`` is no longer required; the same effect can be
achieved by returning the argument *hash-state* unchanged as the result
*hash-state*. Finally, :func:`object-hash` has been altered to use the new
protocol.

This section describes the items that have been changed. We also provide
a Table-extensions module, which you can read about in
:doc:`../collections/table-extensions`.

.. generic-function:: table-protocol
   :open:

   Returns functions used to implement the iteration protocol for tables.

   :signature: table-protocol *table* => *test-function* *hash-function*

   :parameter table: An instance of :drm:`<table>`.
   :value test-function: An instance of :drm:`<function>`.
   :value hash-function: An instance of :drm:`<function>`.

   :description:

     Returns the functions used to iterate over tables. These functions are
     in turn used to implement the other collection operations on :drm:`<table>`.

     The *test-function* argument is for the table test function, which is
     used to compare table keys. It returns true if, according to the table’s
     equivalence predicate, the keys are members of the same equivalence
     class. Its signature must be::

       test-function *key1* *key2* => *boolean*

     The *hash-function* argument is for the table hash function, which
     computes the hash code of a key. Its signature must be::

       hash-function *key* *initial-state* => *id* *result-state*

     In this signature, *initial-state* is an instance of ``<hash-state>``.
     The hash function computes the hash code of *key*, using the hash
     function that is associated with the table’s equivalence predicate. The
     hash code is returned as two values: an integer *id* and a hash-state
     *result-state*. This *result-state* is obtained by merging the
     *initial-state* with the hash-state that results from hashing *key*.
     The *result-state* may or may not be == to *initial-state*. The
     *initial-state* could be modified by this operation.

.. function:: merge-hash-ids

   Returns a hash ID created by merging two hash IDs.

   :signature: merge-hash-ids *id1* *id2* #key *ordered* => *merged-id*

   :parameter id1: An instance of :drm:`<integer>`.
   :parameter id2: An instance of :drm:`<integer>`.
   :parameter ordered: An instance of :drm:`<boolean>`. Default value: ``#f``.
   :value merged-id: An instance of :drm:`<integer>`.

   :description:

     Computes a new hash ID by merging the argument hash IDs in some
     implementation-dependent way. This can be used, for example, to
     generate a hash ID for an object by combining hash IDs of some of
     its parts.

     The *id1*, *id2* arguments and the return value *merged-id* are all
     integers.

     The *ordered* argument is a boolean, and determines whether the
     algorithm used to the merge the IDs is permitted to be
     order-dependent. If false (the default), the merged result must be
     independent of the order in which the arguments are provided. If
     true, the order of the arguments matters because the algorithm used
     need not be either commutative or associative. It is best to
     provide a true value for *ordered* when possible, as this may
     result in a better distribution of hash IDs. However, *ordered*
     must only be true if that will not cause the hash function to
     violate the second constraint on hash functions, described on page
     :drm:`123 of the DRM <Tables#XREF-1049>`.

.. function:: object-hash

   The hash function for the equivalence predicate ==.

   :signature: object-hash *object* *initial-state* => *hash-id* *result-state*

   :parameter object: An instance of :drm:`<integer>`.
   :parameter initial-state: An instance of ``<hash-state>``.
   :value hash-id: An instance of :drm:`<integer>`.
   :value result-state: An instance of ``<hash-state>``.

   :description:

     Returns a hash code for *object* that corresponds to the
     equivalence predicate ``==``.

     This function is a useful tool for writing hash functions in which
     the object identity of some component of a key is to be used in
     computing the hash code.

     It returns a hash ID (an integer) and the result of merging the
     initial state with the associated hash state for the object,
     computed in some implementation-dependent manner.

Limited Collections
-------------------

To improve type safety of limited collections, Open Dylan implements an
extension to the :drm:`make` and :drm:`limited` functions. Normally, when
calling :drm:`make` on a collection that supports the ``fill:`` init-keyword,
that keyword defaults to ``#f``. This value can be inappropriate for a limited
collection. The :drm:`limited` function in Open Dylan accepts a
``default-fill:`` keyword argument which replaces the default of ``#f`` with a
user-specified value; this value is used by :drm:`make` and :drm:`size-setter`
when initializing or adding elements to those collections.

Open Dylan also implements the :func:`element-type` and
:func:`element-type-fill` functions to further improve type safety.

.. function:: limited

   Open Dylan implements the following altered signatures.

   :signature: limited singleton(<array>) #key *of* *size* *dimensions* *default-fill* => *type*
   :signature: limited singleton(<vector>) #key *of* *size* *default-fill* => *type*
   :signature: limited singleton(<simple-vector>) #key *of* *size* *default-fill* => *type*
   :signature: limited singleton(<stretchy-vector>) #key *of* *default-fill* => *type*
   :signature: limited singleton(<deque>) #key *of* *default-fill* => *type*
   :signature: limited singleton(<string>) #key *of* *size* *default-fill* => *type*
   
   :param #key default-fill:
      The default value of the ``fill:`` keyword argument to the :drm:`make`
      function, replacing ``#f``. Optional. If not supplied, the default
      value for the ``default-fill:`` argument and thus for the ``fill:``
      argument to :drm:`make` is ``#f`` (or ``' '`` for strings).
   
   :example:
      
      .. code-block:: dylan
        
        define constant <answers-vector>
            = limited(<vector>, of: <object>, default-fill: 42);
        let some-answers = make(<answers-vector>, size: 3);
        // #[ 42, 42, 42 ]

.. generic-function:: element-type
   :open:

   Returns the element type of a collection.
   
   :signature: element-type *collection* => *type*
   
   :param collection: An instance of :drm:`<collection>`.
   :value type:       The permitted element type of the collection.

.. generic-function:: element-type-fill
   :open:
   
   Returns a valid object that may be used for new elements of a collection.
   
   :signature: element-type-fill *collection* => *object*
   
   :param collection: An instance of :drm:`<collection>` that supports the
                      ``fill:`` init-keyword.
   :value object:     An object.
   
   :discussion: For limited collections, this object will be the defaulted or
                supplied ``default-fill:`` argument to the :func:`limited`
                function.
