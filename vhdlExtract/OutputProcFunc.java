
public interface OutputProcFunc<T> {
	public boolean putValue(T inp);
	public T getFinalResult();
}
