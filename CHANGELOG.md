# CHANGELOG

## 0.4.2 (2024-07-17)

* Rename `fullname` to `full_name`

## 0.4.1 (2024-07-17)

* Add `fullname` to `ModuleNode` and `ClassNode`

## 0.4.0 (2024-07-16)

* Require `prism_ext/parent_node_ext` back

## 0.3.8 (2024-07-06)

* Fix `StringNode#opening` is nil

## 0.3.7 (2024-07-06)

* Fix call node with block_argument_node `to_source`
* Use `character_offset` instead of `offset`

## 0.3.6 (2024-07-03)

* Check `arguments` is an `ArgumetnsNode`

## 0.3.5 (2024-07-03)

* Fix call node with heredoc argument `to_source`

## 0.3.4 (2024-07-02)

* Fix call node `to_source`

## 0.3.3 (2024-07-02)

* Fix heredoc `to_source`

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
