import test from "node:test";
import assert from "node:assert/strict";
import { parseTopics, matches } from "../assets/js/publications.js";

const empty = { query: "", firstAuthor: "", author: "", topic: "" };
const entry = {
  text: "Some Paper Journal of Things 2022 @article{x}",
  firstAuthor: "Ami Hauptman",
  authors: ["Ami Hauptman", "Achiya Elyasaf"],
  topics: ["Evolutionary Computation"],
};

test("parseTopics splits without spaces", () => {
  assert.deepEqual(parseTopics("Behavioral Programming,Deep Learning"), ["Behavioral Programming", "Deep Learning"]);
});
test("parseTopics trims, drops empties, dedupes", () => {
  assert.deepEqual(parseTopics(" A, B ,A,, "), ["A", "B"]);
});
test("parseTopics empty", () => {
  assert.deepEqual(parseTopics(""), []);
});
test("query requires all terms, case-insensitive", () => {
  assert.equal(matches(entry, { ...empty, query: "journal 2022" }), true);
  assert.equal(matches(entry, { ...empty, query: "JOURNAL 2022" }), true);
  assert.equal(matches(entry, { ...empty, query: "journal 2021" }), false);
});
test("topic filter", () => {
  assert.equal(matches(entry, { ...empty, topic: "Deep Learning" }), false);
  assert.equal(matches(entry, { ...empty, topic: "Evolutionary Computation" }), true);
});
test("author vs first author", () => {
  assert.equal(matches(entry, { ...empty, author: "Achiya Elyasaf" }), true);
  assert.equal(matches(entry, { ...empty, firstAuthor: "Achiya Elyasaf" }), false);
  assert.equal(matches(entry, { ...empty, firstAuthor: "Ami Hauptman" }), true);
});
test("empty state matches everything", () => {
  assert.equal(matches(entry, empty), true);
  assert.equal(matches({ text: "", firstAuthor: "", authors: [], topics: [] }, empty), true);
});
