package com.carlca.bitwig;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.charset.StandardCharsets;
import java.nio.ByteBuffer;

public class Parser {

	public static void main(String[] args) {
		if (args.length == 0) {
			generateDummyOutput();
		} else {
			boolean debug = args.length == 2 && args[1].equals("debug");
			processPreset(args[0], debug);
		}
	}

	private static void generateDummyOutput() {
		System.out.println();
	}

	private static void processPreset(String filename, boolean debug) {
		try (RandomAccessFile file = new RandomAccessFile(new File(filename), "r")) {
			int pos = 0x36;
			int size;
			do {
				ReadResult result = readKeyAndValue(file, pos, debug);
				pos = result.getPos(); size = result.getSize();
			} while (size != 0);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private static ReadResult readKeyAndValue(RandomAccessFile file, int pos, boolean debug) throws IOException {
		int size;
		byte[] data;
		int skips = getSkipSize(file, pos);
		if (debug) {
			getSkipSizeDebug(file, pos);
			System.out.printf("%d skips\n", skips);
		}
		pos += skips;
		ReadResult result = readNextSizeAndChunk(file, pos);
		pos = result.getPos(); size = result.getSize(); data = result.getData();
		if (size == 0) {
			return new ReadResult();
		}
		printOutput(size, pos, data);

		skips = getSkipSize(file, pos);
		if (debug) {
			getSkipSizeDebug(file, pos);
			System.out.printf("%d skips\n", skips);
		}
		pos += skips;
		result = readNextSizeAndChunk(file, pos);
		pos = result.getPos(); size = result.getSize(); data = result.getData();
		printOutput(size, pos, data);
		System.out.println();
		return new ReadResult(pos, size);
	}

	private static int getSkipSize(RandomAccessFile file, int pos) throws IOException {
		byte[] bytes = readFromFile(file, pos, 32, false).getData();
		int[] check = new int[]{5, 8, 13};
		for (int i = 0; i < bytes.length; i++) {
			if ((bytes[i] >= 0x20) && (inArray(check, i & 255))) {
				return i - 4;
			}
		}
		return 1;
	}

	private static boolean inArray(int[] array, int element) {
		for (int i : array) {
			if (i == element) {
				return true;
			}
		}
		return false;
	}

	private static void getSkipSizeDebug(RandomAccessFile file, int pos) throws IOException {
		byte[] bytes = readFromFile(file, pos, 32, false).getData();
		for (byte b : bytes) {
			System.out.printf("%02x ", b);
		}
		System.out.println();
		for (byte b : bytes) {
			if (b >= 0x41) {
				System.out.printf(".%c.", b);
			} else {
				System.out.print("   ");
			}
		}
		System.out.println();
	}

	private static void printOutput(int size, int pos, byte[] data) {
		System.out.printf("size: %x\n", size);
		System.out.printf("stringPos: %x\n", pos);
		System.out.println("text: " + new String(data, StandardCharsets.UTF_8));
	}

	private static ReadResult readNextSizeAndChunk(RandomAccessFile file, int pos) throws IOException {
		int size;
		ReadResult intChunk = readIntChunk(file, pos);
		pos = intChunk.getPos(); size = intChunk.getSize();
		if (size == 0) {
			return new ReadResult(pos, 0);
		}
		return readFromFile(file, pos, size, true);
	}

	private static ReadResult readIntChunk(RandomAccessFile file, int pos) throws IOException {
		ReadResult newRead = readFromFile(file, pos, 4, true);
		return new ReadResult(newRead.getPos(), ByteBuffer.wrap(newRead.getData()).getInt());
	}

	private static ReadResult readFromFile(RandomAccessFile file, int pos, int size, boolean advance) throws IOException {
		byte[] res = new byte[size];
		file.seek(pos);
		try {
			file.readFully(res);
		} catch (IOException e) {
			return new ReadResult();
		}
		if (advance) pos += size;
		return new ReadResult(pos, size, res);
	}
}
