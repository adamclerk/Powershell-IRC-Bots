function global:Repeat-String([string]$str, [int]$repeat) {
  $builder = new-object System.Text.StringBuilder
  for ($i = 0; $i -lt $repeat; $i++) {[void]$builder.Append($str)}
  $builder.ToString()
}