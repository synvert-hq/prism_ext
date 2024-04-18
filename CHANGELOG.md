# CHANGELOG

## 0.3.2 (2024-04-18)

* Remove `hash_element` and `hash_value` methods

## 0.3.1 (2024-04-12)

* Skip `AssocSplatNode` for hash helper methods

## 0.3.0 (2024-04-07)

* Abstract `prism_ext/parent_node_ext`
* Inject hash helper methods only to `HashNode` and `KeywordHashNode`

## 0.2.3 (2024-02-17)

* Remove `Prism::Node#source` hack

## 0.2.2 (2024-02-11)

* Reuse `respond_to_elements?`

## 0.2.1 (2024-02-11)

* Check both `HashNode` and `KeywordHashNode`.

## 0.2.0 (2024-02-10)

* Set `parent_node` to `Prism::Node`.

## 0.1.0 (2024-02-10)

* Add some helper methods to `Prism::Node`.
