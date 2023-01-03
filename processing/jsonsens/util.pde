// https://stackoverflow.com/questions/20068852/how-to-cast-jsonarray-to-int-array
public static int[] JSonArray2IntArray(JSONArray jsonArray) {
  int[] intArray = new int[jsonArray.size()];
  for (int i = 0; i < intArray.length; ++i) {
    intArray[i] = jsonArray.getInt(i);
  }
  return intArray;
}
