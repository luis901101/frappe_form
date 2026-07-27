/// Kinds of tokens produced by the [JsExpressionLexer].
enum JsTokenType {
  /// A numeric literal, like `1` or `2.5`. A leading sign is a separate unary
  /// operator token.
  number,

  /// A quoted string literal, like `'Option 3'` or `"2025-01-01"`.
  string,

  /// The `true` or `false` keywords.
  boolean,

  /// The `null` or `undefined` keywords.
  nullLiteral,

  /// A variable reference, like `qty` or `doc.check_1`.
  identifier,

  /// Any logical, comparison, arithmetic or unary operator.
  operator,

  /// The `(` grouping token.
  openParen,

  /// The `)` grouping token.
  closeParen,

  /// End of the expression.
  eof,
}
