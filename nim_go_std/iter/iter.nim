type
  Seq*[V] = iterator(): V
  Seq2*[K, V] = iterator(): (K, V)

proc Pull*[V](seq_iter: Seq[V]): (proc(): (V, bool), proc()) =
  # Simplified
  return (nil, nil)
